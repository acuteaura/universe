date := `date -u +"%Y-%m-%d %H:%M:%S%z"`
hostname := `hostname`
substituters := '--option extra-substituters "https://nyx.chaotic.cx" --option extra-trusted-public-keys "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="'

default:
    @just --list

push:
    git add .
    git commit -m "update from {{hostname}}@{{date}}" || true
    git push origin HEAD

rebuild TYPE *FLAGS:
    nix build .#nixosConfigurations.{{ hostname }}.config.system.build.toplevel --log-format internal-json {{FLAGS}} |& nom --json
    nixos-rebuild {{TYPE}} --flake . --sudo

install HOSTNAME *FLAGS:
    nixos-install --flake .#{{HOSTNAME}} {{substituters}} {{FLAGS}}

switch:
    @just rebuild switch

boot:
    @just rebuild boot
