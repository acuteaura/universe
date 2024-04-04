{ config, pkgs, unstable, ... }:
{
  home.packages = with pkgs; [
    kind
    kubectl
    kubectx
    minikube
    kubernetes-helm
    helm-docs
  ];
}