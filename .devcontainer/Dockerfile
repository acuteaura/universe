FROM docker.io/library/alpine:3.21

RUN apk add --no-cache curl fish git
RUN curl --proto '=https' --tlsv1.2 -sSf -L https://install.lix.systems/lix | sh -s -- install linux \
  --extra-conf "sandbox = false" \
  --init none \
  --no-confirm

ENV PATH="${PATH}:/nix/var/nix/profiles/default/bin"
RUN nix profile install nixpkgs#git nixpkgs#fish
