{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    clusterctl
    helm-docs
    k9s
    kind
    kubectl
    kubectx
    kubelogin
    kubernetes-helm
    kustomize
    minikube
  ];
}
