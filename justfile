universe_repo := "~/Code/universe"
date := `date -u --rfc-3339=seconds`

default:
    @just --list

rebuild:
    cd {{universe_repo}}; nix fmt
    sudo nixos-rebuild --flake {{universe_repo}}#nivix switch
    #home-manager --flake {{universe_repo}}#nivix switch

push:
    cd {{universe_repo}}; git add .
    cd {{universe_repo}}; git commit -m "update {{date}}" || true
    cd {{universe_repo}}; git push origin HEAD

update:
    cd {{universe_repo}}; nix flake update
    @just push

darwin-hm:
    nix run home-manager/master -- switch --flake {{universe_repo}}#shell-aarch64-darwin
