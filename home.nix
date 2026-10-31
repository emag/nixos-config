{ config, lib, pkgs, codex-nix, ... }:

{
  home.username = "emag";
  home.homeDirectory = "/home/emag";

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    gh
    (google-chrome.overrideAttrs (oldAttrs: {
      # Give GNOME a direct path to Chrome's icon instead of a theme lookup.
      postFixup = (oldAttrs.postFixup or "") + ''
        substituteInPlace \
          "$out/share/applications/google-chrome.desktop" \
          "$out/share/applications/com.google.Chrome.desktop" \
          --replace-fail "Icon=google-chrome" \
          "Icon=$out/share/icons/hicolor/256x256/apps/google-chrome.png"
      '';
    }))
    wl-clipboard
    codex-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

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

  # Keep Mozc's config writable while enforcing half-width spaces at activation.
  home.activation.mozcHalfWidthSpace = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${pkgs.python3}/bin/python3 ${pkgs.writeText "mozc-half-width-space.py" ''
      import os
      from pathlib import Path

      path = Path(${builtins.toJSON "${config.xdg.configHome}/mozc/config1.db"})
      data = path.read_bytes() if path.exists() else b""
      # Config.space_character_form: protobuf field 47, enum HALF_WIDTH = 2.
      # Singular protobuf fields use the last value; retain all other settings.
      setting = bytes([0xf8, 0x02, 0x02])
      if not data.endswith(setting):
          path.parent.mkdir(parents=True, exist_ok=True)
          with path.open("ab") as stream:
              stream.write(setting)
          os.chmod(path, 0o600)
    ''}
  '';

  # GNOME user settings
  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      audible-bell = false;
    };

    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "ctrl:nocaps" ];
    };
  };

  # Let Home Manager manage itself.
  programs.home-manager.enable = true;
}
