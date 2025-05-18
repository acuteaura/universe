{
  pkgs,
  lib,
  ...
}: let
  relinkSaves = pkgs.writeScript "relink-saves" ''
    #!${pkgs.fish}/bin/fish
    set compatdir_magician /media/steam-library-magician/steamapps/compatdata/

    # expedition
    set co_save_dir "$compatdir_magician/1903340/pfx/drive_c/users/steamuser/AppData/Local/Sandfall/Saved/SaveGames/76561197998319308"
    if not test -L "$co_save_dir"
      if test -d "$co_save_dir"
        printf "Deleting existing save folder"
        rm -r "$co_save_dir"
      end
      printf "Relinking expedition saves\n"
      ln -s /media/wecontinue/steam/clairobscur/ "$co_save_dir"
    end

    # thelongdark
    set tld_save_dir "$compatdir_magician/305620/pfx/drive_c/users/steamuser/AppData/Local/Hinterland/TheLongDark"
    if not test -L "$tld_save_dir"
      if test -d "$tld_save_dir"
        printf "Deleting existing save folder\n"
        rm -r "$tld_save_dir"
      end
      printf "Relinking tld saves\n"
      ln -s /media/wecontinue/steam/thelongdark/ "$tld_save_dir"
    end

    set uplay_save_dir "/home/aurelia/.local/share/bottles/bottles/Ubisoft-Connect/drive_c/Program Files (x86)/Ubisoft/Ubisoft Game Launcher/savegames"
    if not test -L "$uplay_save_dir"
      if test -d "$uplay_save_dir"
        printf "Deleting existing save folder\n"
        rm -r "$uplay_save_dir"
      end
      printf "Relinking uplay saves\n"
      ln -s /media/wecontinue/uplay/ "$uplay_save_dir"
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
