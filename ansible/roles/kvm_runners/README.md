# kvm_runners role

This role prepares a Linux host for KVM/libvirt and provisions cloud image virtual machines by default:

- `runner-01`
- `runner-02`
- `runner-03`
- `runner-04`

The role:

- installs KVM/libvirt and image tooling
- ensures `libvirtd` is running
- configures NAT networking (when `kvm_runners_network_mode: nat`)
- supports bridged networking (when `kvm_runners_network_mode: bridge`)
- supports direct attachment to a host interface (when `kvm_runners_network_mode: direct`)
- downloads the configured cloud image
- creates per-VM qcow2 disks and cloud-init seed ISOs
- creates/starts/autostarts the VMs via `virt-install`
- waits for DHCP leases on DHCP-configured guests and reports expected static guest IPs

## Requirements

- target host supports hardware virtualization
- root privileges on target host
- internet access from target host to download the configured cloud image

## Variables

Defaults are in `defaults/main.yml`.

Key variables:

- `kvm_runners_vms`: VM definitions (name, vcpus, memory, disk size)
- `kvm_runners_cloud_image_url`: cloud image URL
- `kvm_runners_network_mode`: `nat`, `bridge`, or `direct`
- `kvm_runners_network_name`: libvirt network name (default: `default`)
- `kvm_runners_bridge_name`: host bridge interface name (for bridge mode)
- `kvm_runners_direct_interface`: host interface name (for direct mode)
- `kvm_runners_vm_ipv4_prefix`: IPv4 prefix for static guest addresses
- `kvm_runners_vm_ipv4_gateway`: IPv4 gateway for static guest addresses
- `kvm_runners_vm_ipv4_dns_servers`: DNS server list for static guest addresses
- `kvm_runners_default_ssh_public_key_path`: local default key path
- `kvm_runners_ssh_authorized_keys`: SSH keys injected by cloud-init
- `kvm_runners_vm_packages`: in-guest packages installed by cloud-init
- `kvm_runners_vm_admin_groups`: admin groups assigned to the VM user
- `kvm_runners_vm_user_passwordless_sudo`: grant passwordless sudo to VM user (default: `true`)
- `kvm_runners_host_manage_ksm`: enable `ksm`/`ksmtuned` on supported hosts
- `kvm_runners_host_swapfiles`: extra host swapfiles created before VM provisioning

By default, the role reads `~/.ssh/id_ed25519.pub` from the control host.

## Customizing VM definitions

Override `kvm_runners_vms` to set names and sizing:

```yaml
kvm_runners_vms:
  - name: runner-01
    vcpus: 4
    memory_mb: 8192
    disk_size_gb: 50
  - name: runner-02
    vcpus: 2
    memory_mb: 4096
    disk_size_gb: 30
    ipv4_address: 192.168.0.212
```

## Security and lifecycle notes

- By default, the VM user is configured with passwordless sudo for bootstrap convenience.
  Set `kvm_runners_vm_user_passwordless_sudo: false` to require a password.
- Cloud-init data is applied at first boot. If you change cloud-init templates for existing VMs,
  recreate the VMs to fully apply those changes.
- This role provisions VMs but does not remove them. To tear down:
  - `virsh destroy <name>`
  - `virsh undefine <name> --remove-all-storage`
  - delete any remaining files under `{{ kvm_runners_image_dir }}`

## Example playbook

```yaml
---
- name: Provision KVM runner virtual machines
  hosts: localhost
  become: true
  roles:
    - role: kvm_runners
```

Run:

```bash
ansible-playbook ansible/deployKvmRunners.yml
```

For UAT and staging on Ubuntu with Podman:

```bash
ansible-playbook ansible/deployUat.yml
```

`deployUat.yml` defines `uat_vms` as a list, so additional UAT instances can be
added by appending entries to that list.
