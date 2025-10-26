# NixOS Configuration
![showcase](https://github.com/hman0/nixos-config/blob/master/showcase/showcase.png)
This NixOS config offers two compositor options — niri and mangowc — both tailored to look and behave as identical as possible for a consistent experience.
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

### Notice 
This NixOS configuration assumes the system username is set to **hman**.  
If you plan to use a different username, you will need to update configuration files accordingly.

