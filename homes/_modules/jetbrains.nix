{ config, pkgs, ... }:
let
  jbpkgs = import
    (builtins.fetchTarball {
      url = https://github.com/NixOS/nixpkgs/archive/c2fbe8c06eec0759234fce4a0453df200be021de.tar.gz;
      sha256 = "sha256:1lhwzgzb0kr12903d1y5a2afghkknx9wgypisnnfz6xg2c6993wz";
    })
    {
      system = "x86_64-linux";
      config = {
        allowUnfree = true;
      };
    };
in
{
  home.packages = with jbpkgs; [
    (jetbrains.plugins.addPlugins jetbrains.goland [ "github-copilot" ])
  ];
}
