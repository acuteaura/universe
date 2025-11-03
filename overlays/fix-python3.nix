super: self: {
  pgadmin4-desktopmode = self.pgadmin4-desktopmode.override {python3 = super.python312;};
  handbrake = self.handbrake.override {python3 = super.python312;};
}
