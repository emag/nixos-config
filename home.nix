{ config, pkgs, ... }:

{
  home.username = "emag";
  home.homeDirectory = "/home/emag";

  home.stateVersion = "26.05";

  # Git
  programs.git = {
    enable = true;

    settings = {
      user.name = "emag";
      user.email = "1188893+emag@users.noreply.github.com";
      init.defaultBranch = "main";
    };
  };

  # Vim
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  # GNOME user settings
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "ctrl:nocaps" ];
    };
  };

  # Let Home Manager manage itself.
  programs.home-manager.enable = true;
}

