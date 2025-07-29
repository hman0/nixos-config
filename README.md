# NixOS Configuration

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
