{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Network
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Time / Locale
  time.timeZone = "Asia/Tokyo";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "ja_JP.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "ja_JP.UTF-8";
    LC_NAME = "ja_JP.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "ja_JP.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "ja_JP.UTF-8";
  };

  # GNOME
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Prefer Japanese glyphs consistently in desktop and Java applications.
  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      jetbrains-mono
    ];

    fontconfig.defaultFonts = {
      sansSerif = [ "Noto Sans CJK JP" ];
      serif = [ "Noto Serif CJK JP" ];
      monospace = [
        "JetBrains Mono"
        "Noto Sans Mono CJK JP"
      ];
    };
  };

  # Keyboard
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = "ctrl:nocaps";
  };

  console.useXkbConfig = true;

  # NVIDIA / Intel hybrid GPU
  hardware.nvidia = {
    open = true;

    prime.offload = {
      enable = true;
      enableOffloadCmd = true;
    };
  };

  # Printing
  services.printing.enable = true;

  # Sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # User
  programs.zsh.enable = true;

  users.users.emag = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "emag";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Firefox
  programs.firefox.enable = true;

  # Required by the Codex Linux sandbox.
  environment.systemPackages = with pkgs; [
    bubblewrap
  ];

  # Unfree packages
  nixpkgs.config.allowUnfree = true;

  # Nix command / flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Japanese input
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
  };

  system.stateVersion = "26.05";
}
