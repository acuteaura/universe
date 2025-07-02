super: self: {
  azure-cli = self.azure-cli.override {python3 = super.python312;};
  archivebox = self.archivebox.override {python3 = super.python312;};
  pgadmin4-desktopmode = self.pgadmin4-desktopmode.override {python3 = super.python312;};
  handbrake = self.handbrake.override {python3 = super.python312;};
}
