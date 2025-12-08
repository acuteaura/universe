# Tailscale TSKEY Management Guide (Without Nix Secrets)

This guide explains how to manage Tailscale auth keys (TSKEY) for container deployments without using Nix's secrets management system.

## Quick Start

### 1. Generate a Tailscale Auth Key

Generate an auth key in your Tailscale admin panel:
- Go to https://login.tailscale.com/admin/settings/keys
- Click "Generate auth key"
- Options to consider:
  - **Reusable**: Enable if you want to use this key for multiple containers
  - **Ephemeral**: Enable if you want nodes to be removed when the container stops
  - **Pre-approved**: Enable to skip manual approval
  - **Tags**: Add tags like `tag:container` for ACL management
- Copy the generated key (starts with `tskey-auth-...`)

### 2. Store the Key Securely

#### Option A: Simple File Storage (Quick & Dirty)

Create a file outside your Nix configuration:

```bash
# Create a directory for secrets (outside git repo)
sudo mkdir -p /etc/tailscale-keys
sudo chmod 700 /etc/tailscale-keys

# Store the key
echo "tskey-auth-XXXXXXXXXXXXXXXXXXXXXXXX" | sudo tee /etc/tailscale-keys/container-key
sudo chmod 600 /etc/tailscale-keys/container-key
```

Then reference it in your NixOS configuration:

```nix
universe.tailscale-sidecar = {
  enable = true;
  authKeyFile = "/etc/tailscale-keys/container-key";
  hostname = "my-container";
};
```

**Pros:**
- Simple and straightforward
- No additional tooling needed
- Works immediately

**Cons:**
- Key stored in plaintext on disk
- Not backed up automatically
- Manual management across multiple systems

#### Option B: Environment File with systemd

Store the key in an environment file that systemd loads. **Note:** On NixOS, you must configure this through your NixOS configuration, not by manually creating files in `/etc/systemd`.

```bash
# Create a directory for environment files (outside git repo)
sudo mkdir -p /var/lib/tailscale-keys
sudo chmod 700 /var/lib/tailscale-keys

# Create environment file
echo "TS_AUTHKEY=tskey-auth-XXXXXXXXXXXXXXXXXXXXXXXX" | \
  sudo tee /var/lib/tailscale-keys/sidecar.env
sudo chmod 600 /var/lib/tailscale-keys/sidecar.env
```

Configure the systemd service in your NixOS configuration:

```nix
# First store the key file location
universe.tailscale-sidecar = {
  enable = true;
  # You can still use authKeyFile, or alternatively:
  authKeyFile = null;  # Disable file-based auth
  hostname = "my-container";
};

# Override the systemd service to use environment file
systemd.services.podman-tailscale-sidecar = {
  serviceConfig = {
    EnvironmentFile = "/var/lib/tailscale-keys/sidecar.env";
  };
};
```

**Pros:**
- Standard systemd pattern
- Environment isolated per service
- NixOS-managed systemd configuration

**Cons:**
- Still plaintext on disk
- Requires NixOS rebuild to change configuration

#### Option C: Pass Store (Recommended for Multiple Systems)

Use the Unix password manager `pass` for encrypted storage:

```bash
# Initialize pass (if not already done)
gpg --full-generate-key  # Create GPG key if needed
pass init "your-gpg-key-id"

# Store the Tailscale key
pass insert tailscale/container-key
# Paste your tskey-auth-... when prompted

# Retrieve it for verification
pass tailscale/container-key
```

Create a helper script to extract the key:

```bash
sudo mkdir -p /etc/tailscale-keys
sudo tee /etc/tailscale-keys/extract-key.sh <<'EOF'
#!/usr/bin/env bash
pass tailscale/container-key
EOF
sudo chmod 700 /etc/tailscale-keys/extract-key.sh
```

Modify your activation script or use a systemd ExecStartPre:

```nix
systemd.services.podman-tailscale-sidecar = {
  serviceConfig = {
    ExecStartPre = "${pkgs.writeShellScript "extract-tskey" ''
      ${pkgs.pass}/bin/pass tailscale/container-key > /run/tailscale-sidecar/tskey
      chmod 600 /run/tailscale-sidecar/tskey
    ''}";
  };
};
```

Then reference `/run/tailscale-sidecar/tskey` as your `authKeyFile`.

**Pros:**
- Encrypted at rest with GPG
- Can be synced across systems via git
- Standard Unix tool
- Supports team access via GPG keys

**Cons:**
- Requires GPG setup
- More complex initial setup
- Need to handle key extraction at runtime

#### Option D: Hardware Token / YubiKey

For maximum security, use a hardware token:

```bash
# Store key encrypted with YubiKey PIV
echo "tskey-auth-XXXXXXXXXXXXXXXXXXXXXXXX" | \
  age -r "$(ssh-keygen -D /usr/lib/libykcs11.so -e | grep ecdsa)" \
  > /etc/tailscale-keys/container-key.age
```

Decrypt at runtime with systemd ExecStartPre. Requires YubiKey to be present.

**Pros:**
- Key never stored in plaintext
- Requires hardware token presence
- Strongest security option

**Cons:**
- Complex setup
- YubiKey must be present for container to start
- Not suitable for remote/headless systems

## Configuration Examples

### Example 1: ComfyUI with Tailscale (No Port Mapping)

```nix
universe.tailscale-sidecar = {
  enable = true;
  authKeyFile = "/etc/tailscale-keys/container-key";
  hostname = "comfyui-server";
  extraArgs = ["--advertise-tags=tag:ai-containers"];
};

universe.comfyui-container = {
  enable = true;
  useTailscaleSidecar = true;
  # portMappings left empty - access via Tailscale hostname
  autoStart = true;
  dataDir = "/var/lib/comfyui";
};
```

Access ComfyUI at: `http://comfyui-server:8188` from any Tailscale device.

### Example 2: Multiple Containers Sharing One Sidecar

```nix
universe.tailscale-sidecar = {
  enable = true;
  authKeyFile = "/etc/tailscale-keys/ai-services-key";
  hostname = "ai-services";
};

universe.comfyui-container = {
  enable = true;
  useTailscaleSidecar = true;
  autoStart = true;
};

universe.invokeai-container = {
  enable = true;
  useTailscaleSidecar = true;
  autoStart = true;
};

# Access:
# - ComfyUI: http://ai-services:8188
# - InvokeAI: http://ai-services:9090
```

### Example 3: Hybrid Mode (Tailscale + Local Port)

```nix
universe.tailscale-sidecar = {
  enable = true;
  authKeyFile = "/etc/tailscale-keys/ollama-key";
  hostname = "ollama-server";
};

universe.ollama-container = {
  enable = true;
  useTailscaleSidecar = true;
  # Also expose locally for debugging
  portMappings = ["127.0.0.1:11434:11434"];
  autoStart = true;
};

# Access:
# - From Tailscale: http://ollama-server:11434
# - Locally: http://localhost:11434
```

## Security Best Practices

### 1. Key Rotation

Tailscale auth keys should be rotated periodically:

```bash
# Generate new key in Tailscale admin
# Update the stored key
echo "tskey-auth-NEWKEYXXXXXXXXXXXXXXXX" | sudo tee /etc/tailscale-keys/container-key

# Restart container to use new key
sudo systemctl restart podman-tailscale-sidecar
```

### 2. Use Tags for ACL Management

Generate keys with tags to restrict access:

```hcl
# In Tailscale ACL
{
  "tagOwners": {
    "tag:ai-containers": ["autogroup:admin"],
  },
  "acls": [
    {
      "action": "accept",
      "src": ["group:trusted-users"],
      "dst": ["tag:ai-containers:*"]
    }
  ]
}
```

Then use `--advertise-tags=tag:ai-containers` in `extraArgs`.

### 3. Ephemeral Nodes

For temporary containers, use ephemeral auth keys:

```nix
universe.tailscale-sidecar = {
  enable = true;
  authKeyFile = "/etc/tailscale-keys/ephemeral-key";  # Generated with --ephemeral
  hostname = "temp-dev-container";
};
```

The node automatically disappears when the container stops.

### 4. File Permissions

Always ensure restrictive permissions:

```bash
# Key files should be readable only by root
sudo chown root:root /etc/tailscale-keys/*
sudo chmod 600 /etc/tailscale-keys/*

# Directory should not be world-readable
sudo chmod 700 /etc/tailscale-keys
```

### 5. Exclude from Git

Add to `.gitignore`:

```gitignore
/etc/tailscale-keys/
*.tskey
tskey-*
```

Never commit Tailscale keys to version control.

## Troubleshooting

### Container Can't Connect to Tailscale

Check logs:
```bash
journalctl -u podman-tailscale-sidecar -f
```

Common issues:
- **"authentication key invalid"**: Key expired or already used (if not reusable)
- **"unauthorized"**: Key doesn't have required permissions
- **"device already exists"**: Hostname already taken (remove old device or use different hostname)

### Dependent Container Starts Before Sidecar

Check systemd dependencies:
```bash
systemctl status podman-ollama
systemctl status podman-tailscale-sidecar
```

The refactored modules include automatic `requires` and `after` directives.

### Can't Access Container via Tailscale

Verify Tailscale connectivity:
```bash
# From another Tailscale device
tailscale ping comfyui-server

# Check if ports are listening inside container
podman exec tailscale-sidecar netstat -tlnp
```

## Migration from Port-Based to Tailscale

Before:
```nix
universe.ollama-container = {
  enable = true;
  listenAddress = "0.0.0.0";  # Old option - removed
  listenPort = 11434;          # Old option - removed
};
```

After:
```nix
universe.tailscale-sidecar = {
  enable = true;
  authKeyFile = "/etc/tailscale-keys/ollama-key";
  hostname = "ollama";
};

universe.ollama-container = {
  enable = true;
  useTailscaleSidecar = true;
  portMappings = [];  # Empty - no local ports exposed
};
```

## Advanced: Per-Container Sidecars

If you need isolated Tailscale nodes per container (different hostnames/ACLs):

```nix
# Not yet implemented, but possible by creating multiple sidecar services
# Would require extending the sidecar module to accept a name parameter
```

## References

- Tailscale auth keys: https://tailscale.com/kb/1085/auth-keys
- Tailscale ACLs: https://tailscale.com/kb/1018/acls
- Podman networking: https://docs.podman.io/en/latest/markdown/podman-run.1.html#network
- Container network namespaces: https://github.com/tailscale-dev/docker-guide-code-examples/blob/main/PODMAN_COMPATIBILITY.md
