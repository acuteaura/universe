date := `date -u +"%Y-%m-%d %H:%M:%S%z"`
hostname := `hostname`

default:
    @just --list

push:
    git add .
    git commit -m "update from {{hostname}}@{{date}}" || true
    git push origin HEAD

rebuild TYPE *FLAGS:
    nix build .#nixosConfigurations.{{ hostname }}.config.system.build.toplevel --log-format internal-json {{FLAGS}} |& nom --json
    nixos-rebuild {{TYPE}} --flake . --sudo
