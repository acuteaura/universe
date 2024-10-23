{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    helm-docs
    k9s
    kind
    kubectl
    kubectx
    kubelogin
    kubernetes-helm
    minikube
  ];
}
