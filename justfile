date := `date -u +"%Y-%m-%d %H:%M:%S%z"`

default:
    @just --list

push:
    git add .
    git commit -m "update {{date}}" || true
    git push origin HEAD

rebuild TYPE *FLAGS:
    sudo fish -c "nixos-rebuild {{TYPE}} --flake . --log-format internal-json {{FLAGS}} &| nom --json"
