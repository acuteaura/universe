final: prev: {
  brave = prev.brave.override {
    vulkanSupport = true;
    commandLineArgs = "--password-store=gnome-libsecret";
  };
}
