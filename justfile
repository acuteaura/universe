date := `date -u +"%Y-%m-%d %H:%M:%S%z"`

default:
    @just --list

push:
    git add .
    git commit -m "update {{date}}" || true
    git push origin HEAD

rebuild TYPE *FLAGS:
    #!/usr/bin/env fish
    nixos-rebuild {{TYPE}} --flake . --log-format internal-json --sudo {{FLAGS}} &| nom --json
