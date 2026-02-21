# kvm_runners role

This role prepares a Linux host for KVM/libvirt and provisions Ubuntu cloud image virtual machines by default:

- `runner-01`
- `runner-02`
- `runner-03`
- `runner-04`

The role:

- installs KVM/libvirt and image tooling
- ensures `libvirtd` is running
- ensures the libvirt network is configured for NAT
- downloads an Ubuntu cloud image
- creates per-VM qcow2 disks and cloud-init seed ISOs
- creates/starts/autostarts the VMs via `virt-install`
- waits for DHCP leases to verify guest networking

## Requirements

- target host supports hardware virtualization
- root privileges on target host
- internet access from target host to download the Ubuntu cloud image

## Variables

Defaults are in `defaults/main.yml`.

Key variables:

- `kvm_runners_vms`: VM definitions (name, vcpus, memory, disk size)
- `kvm_runners_cloud_image_url`: Ubuntu cloud image URL
- `kvm_runners_network_name`: libvirt network name (default: `default`)
- `kvm_runners_default_ssh_public_key_path`: local default key path
- `kvm_runners_ssh_authorized_keys`: SSH keys injected by cloud-init
- `kvm_runners_vm_user_passwordless_sudo`: grant passwordless sudo to VM user (default: `true`)

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
