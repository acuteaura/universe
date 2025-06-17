date := `date -u +"%Y-%m-%d %H:%M:%S%z"`

default:
    @just --list

push:
    git add .
    git commit -m "update {{date}}" || true
    git push origin HEAD

switch:
    sudo fish -c "nixos-rebuild switch --flake . --log-format internal-json &| nom --json"

boot:
    sudo fish -c "nixos-rebuild boot --flake . --log-format internal-json &| nom --json"
