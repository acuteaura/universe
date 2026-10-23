{...}: {
  services.cyac = {
    enable = true;
    kernel = "kvm"; # enables Firecracker on KVM hosts
    proxy = {
      openFirewall = true;
    };
  };
}
