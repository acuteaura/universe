{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    cilium-cli
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
