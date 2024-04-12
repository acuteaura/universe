{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    helm-docs
    kind
    kubectl
    kubectx
    kubelogin
    kubernetes-helm
    minikube
  ];
}
