# NixOS Configuration
![showcase](https://codeberg.org/hman/nixos-config/raw/branch/master/showcase/showcase.png)
This NixOS config offers two compositor options — niri and mangowc — both tailored to look and behave as identical as possible for a consistent experience.

## Installation

Install a base config NixOS via the Graphical Installer ISO, or boot into the Minimal ISO and install this configuration directly.  These following instructions assume you are using the Minimal ISO.

1. Partition and mount your drives

2. Clone the repo to `/mnt/etc/nixos`
```bash
git clone https://github.com/hman0/nixos-config
```
3. Generate a hardware configuration for your system
```bash
nixos-generate-config --root /mnt
```
4. Configure the system

> [!NOTE]
> This NixOS configuration assumes the system username is set to **hman**. If you plan to use a different username, you will need to update configuration files accordingly.

- Set hostname in `configuration.nix` and `flake.nix`

- Set EFI system mount point in `modules/boot.nix`

- Setup video drivers in `modules/drivers.nix` (Nvidia is configured by default, and Nvidia + Intel hybrid setup is configured in the `laptop` branch)
5. Install the system
```bash
nixos-install --flake /mnt/etc/nixos#when-they-cry
```
> [!WARNING]
> The installation will likely fail due to Secure Boot and Secrets Management not being set up. Follow the instructions below to configure these features, or remove all references to them from the config files to continue without them.

**Note:** You may need to run `nixos-enter` to chroot into the installation before configuring these features.

## Build System

Rebuild and switch to the new configuration:

```bash
doas nixos-rebuild switch --flake /etc/nixos
```

Update packages when desired:

```bash
doas nix flake update
```

## Secrets Management

### Setup

Create the secrets directory:

```bash
mkdir -p ~/nix/secrets
```

### Configuration

Create `secrets.nix` with the following structure:

```nix
{
  git_email = "hman@example.com";
  psk_vm = "EXAMPLE_WIFI_PASSWORD";
}
```

### Updates

Update secrets configuration:

```bash
doas nix flake update secrets
```

## Secure Boot

Create Secure Boot keys:

```bash
doas sbctl create-keys
```

---


