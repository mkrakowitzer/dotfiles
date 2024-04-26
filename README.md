# dotfiles

This repository contains my dotfiles that can be installed via the `setup` script.

It configures my environment just the way I like it.

Tools that are installed and configured are:

- oh-my-zsh
- tmux
- neovim
- git
- golang
- rust
- npm
- yubikey tools
- docker
- kubernetes tools (kubectl, kind, heml)

It should work with RedHat, Debian and in the future MacOS based systems.

## Installation

Run the following commands to install, the below script will install ansible and
run the playbook to install the dotfiles.

```bash
mkdir personal
cd personal
curl https://raw.githubusercontent.com/mkrakowitzer/dotfiles/main/setup | sh
```

## Testing

Currently I test using wsl2 on windows 11.  The following script will create a
new wsl2 instance and install the dotfiles.

```shell
# Part 1
wsl --unregister ubuntu-2
wsl --import ubuntu-2 "c:\Users\merri\Documents\ubuntu2" ubuntu-22.04-wsl-rootfs.tar.gz
wsl -d  ubuntu-2

NEW_USER=krakowitzerm
PASSWORD=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13)
useradd -m -G sudo -s /bin/bash "$NEW_USER"
echo "$NEW_USER:$PASSWORD" | chpasswd
tee /etc/wsl.conf <<_EOF
[user]
default=${NEW_USER}
_EOF
echo $PASSWORD | tee /home/${NEW_USER}/tmppassword
exit

# Part 2
wsl --terminate ubuntu-2
wsl -d  ubuntu-2
cd ~
mkdir personal
cd personal
curl https://raw.githubusercontent.com/mkrakowitzer/dotfiles/main/setup | sh
```

## Regenerating my ssh keys

```shell
ssh-keygen -K -O no-touch-required
mv id_ed25519_sk_rk id_ed25519_sk_rk_black_with_no_touch
mv id_ed25519_sk_rk.pub id_ed25519_sk_rk_black_with_no_touch.pub

ssh-keygen -K -O no-touch-required
mv id_ed25519_sk_rk iid_ed25519_sk_rk_black_with_touch
mv id_ed25519_sk_rk.pub id_ed25519_sk_rk_black_with_touch.pub

ssh-keygen -K -O no-touch-required
mv id_ed25519_sk_rk iid_ed25519_sk_rk_red_with_no_touch
mv id_ed25519_sk_rk.pub id_ed25519_sk_rk_red_with_no_touch.pub
```

```shell
ssh-keygen -K
mv id_ed25519_sk_rk iid_ed25519_sk_rk_red_with_touch
mv id_ed25519_sk_rk.pub id_ed25519_sk_rk_red_with_touch.pub

ssh-keygen -K
mv id_ed25519_sk_rk iid_ed25519_sk_rk_yubikey_no_touch
mv id_ed25519_sk_rk.pub id_ed25519_sk_rk_yubikey_no_touch.pub

ssh-keygen -K
mv id_ed25519_sk_rk iid_ed25519_sk_rk_yubikey_touch
mv id_ed25519_sk_rk.pub id_ed25519_sk_rk_yubikey_touch.pub
```
