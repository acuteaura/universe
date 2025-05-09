{
  pkgs,
  lib,
  ...
}: let
  relinkSaves = pkgs.writeScript "relink-saves" ''
    #!${pkgs.fish}/bin/fish
    set compatdir /media/steam-library/steamapps/compatdata/

    # expedition
    set co_save_dir "$compatdir/1903340/pfx/drive_c/users/steamuser/AppData/Local/Sandfall/Saved/SaveGames/76561197998319308"
    if not test -L "$co_save_dir"
      if test -d "$co_save_dir"
        printf "Deleting existing save folder"
        rm -r "$co_save_dir"
      end
      printf "Relinking saves"
      ln -s /media/wecontinue/steam/clairobscur/ "$co_save_dir"
    end
  '';
  relinkSavesApp = pkgs.runCommand "wecontinue" {inherit relinkSaves;} ''
    mkdir -p $out/bin
    ln -s $relinkSaves $out/bin/wecontinue
  '';
in {
  services.zfs.autoSnapshot.enable = lib.mkDefault true;

  environment.systemPackages = [relinkSavesApp];
}
