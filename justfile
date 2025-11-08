date := `date -u +"%Y-%m-%d %H:%M:%S%z"`
hostname := `hostname`
substituters := '--option extra-substituters "https://nyx.chaotic.cx" --option extra-trusted-public-keys "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="'

default:
    @just --list

push:
    git add .
    git commit -m "update from {{hostname}}@{{date}}" || true
    git push origin HEAD

build *FLAGS:
    #!/usr/bin/env bash
    set -euo pipefail
    nix build .#nixosConfigurations.{{ hostname }}.config.system.build.toplevel --log-format internal-json {{FLAGS}} |& nom --json
    if command -v attic >/dev/null 2>&1 && attic cache info aurelia >/dev/null 2>&1; then
        echo "Pushing to attic cache..."
        attic push aurelia ./result
    else
        echo "Skipping attic push (attic not configured or cache 'aurelia' not found)"
    fi

rebuild TYPE *FLAGS:
    @just build {{FLAGS}}
    nixos-rebuild {{TYPE}} --flake . --sudo

install HOSTNAME *FLAGS:
    nixos-install --flake .#{{HOSTNAME}} {{substituters}} {{FLAGS}}

switch *FLAGS:
    @just rebuild switch {{FLAGS}}

boot *FLAGS:
    @just rebuild boot {{FLAGS}}

update-dependencies:
    nix flake update nixpkgs home-manager chaotic
    nix flake archive

lint:
    nix run .#lint -- {{ justfile_directory() }}

format:
    nix fmt {{ justfile_directory() }}

check:
    nix flake check --no-build
