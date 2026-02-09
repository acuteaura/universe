{...}: {
  services.wivrn = {
    enable = true;
    openFirewall = true;

    # Write information to /etc/xdg/openxr/1/active_runtime.json, VR applications
    # will automatically read this and work with WiVRn (Note: This does not currently
    # apply for games run in Valve's Proton)
    defaultRuntime = true;

    # Run WiVRn as a systemd service on startup
    autoStart = true;
  };

  # should make steam use wivrn
  environment.sessionVariables = {
    PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES = "1";
  };
}
