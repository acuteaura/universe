date := `date -u +"%Y-%m-%d %H:%M:%S%z"`

default:
    @just --list

push:
    git add .
    git commit -m "update {{date}}" || true
    git push origin HEAD

update:
    nix flake update
    @just push

darwin-hm:
    nix run home-manager/master -- switch --flake .#shell-aarch64-darwin
