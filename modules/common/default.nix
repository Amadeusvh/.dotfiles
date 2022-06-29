{ config, pkgs, home-manager, nur, ... }:
let
  nowl = (import ../../tools/nowl.nix) pkgs;
in
{
  imports = [
    nur.nixosModules.nur
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.users.maxhero = (import ../../home/amadeus);
    }
  ];
  # Better voltage and temperature
  boot.extraModulePackages = with config.boot.kernelPackages; [ zenpower ];

  users.users = {
    amadeus = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = [
        "wheel"
        "video"
        "audio"
        "realtime"
        "libvirt"
        "kvm"
        "input"
        "networkmanager"
        "rtkit"
        "podman"
      ];
      shell = pkgs.bash;
    };
  };

  # Use Systemd Boot
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  environment.systemPackages = with pkgs; [
    acpi
    alacritty
    kitty
    android-tools
    aria2
    avizo
    brave
    btop
    cachix
    discord
    ffmpegthumbnailer
    file
    firefox-wayland
    fzf
    git
    ungoogled-chromium
    grim
    i3status-rust
    gnome3.adwaita-icon-theme
    gnome.eog
    killall
    lm_sensors
    lxqt.pavucontrol-qt
    lxqt.pcmanfm-qt
    mpv
    nowl
    p7zip
    pamixer
    pciutils
    qbittorrent
    slack
    slurp
    spotify
    mako
    tdesktop
    tmux
    unrar
    unzip
    usbutils
    wget
    wpsoffice
    xarchiver
    xdg_utils
    zoom-us

    adbfs-rootless
    notion-app-enhanced
    gimp
    archiver
    dotnet-sdk
    xarchiver
    waybar
    helvum
    neofetch
    nix-index
    nmap
    traceroute
    radeontop
    lolcat
    cowsay
    filezilla
    fortune
    zsh
    bat
    gparted

    # Theming
    orchis-theme
    ntfs3g
    libsForQt5.dolphin
    libsForQt5.dolphin-plugins
    tela-circle-icon-theme
  ];

  hardware.bluetooth.enable = true;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      rocm-opencl-icd
      rocm-opencl-runtime
    ];
  };

  # Ativa o Cereal Real
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nix.settings = {
    trusted-users = [ "root" "maxhero" ];
    auto-optimise-store = true;
    substituters =
      [ "https://nix-gaming.cachix.org" "https://nixpkgs.cachix.org" ];
    trusted-public-keys = [
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="
    ];
  };

  nixpkgs.config.allowUnfree = true;

  fonts.fontconfig.allowBitmaps = true;
  fonts.fonts = with pkgs; [
    cantarell-fonts
    font-awesome_4
    font-awesome_5
    freefont_ttf
    google-fonts
    liberation_ttf
    noto-fonts
    ubuntu_font_family
    scientifica
    curie
  ];

  i18n = {
    defaultLocale = "en_GB.UTF-8";
    inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ mozc ];
    };
    supportedLocales = [
      "en_GB.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "pt_BR.UTF-8/UTF-8"
      "ja_JP.UTF-8/UTF-8"
    ];
    extraLocaleSettings = {
      LC_TIME = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
    };
  };

  programs.dconf.enable = true;
  programs.fish.enable = true;
  programs.nm-applet.enable = true;
  programs.waybar.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      swaynotificationcenter
      wl-clipboard
      libinput
      libinput-gestures
      wofi
    ];
    extraSessionCommands = ''
      # Force wayland overall.
      export CLUTTER_BACKEND='wayland'
      export ECORE_EVAS_ENGINE='wayland_egl'
      export ELM_ENGINE='wayland_egl'
      export GDK_BACKEND='wayland'
      export MOZ_ENABLE_WAYLAND=1
      export QT_AUTO_SCREEN_SCALE_FACTOR=0
      export QT_QPA_PLATFORM='wayland-egl'
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export SAL_USE_VCLPLUGIN='gtk3'
      export SDL_VIDEODRIVER='wayland'
      export _JAVA_AWT_WM_NONREPARENTING=1
      export NIXOS_OZONE_WL=1

      # KDE/Plasma platform for Qt apps.
      export QT_QPA_PLATFORMTHEME='kde'
      export QT_PLATFORM_PLUGIN='kde'
      export QT_PLATFORMTHEME='kde'

      export GTK_IM_MODULE='ibus'
      export QT_IM_MODULE='ibus'
      export XMODIFIERS='@im=ibus'
      export GTK_IM_MODULE='/run/current-system/sw/lib/gtk-2.0/2.10.0/immodules/im-ibus.so'
    '';
  };

  xdg.portal = {
    wlr.enable = true;
    extraPortals = with pkgs;
      [
        #xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
  };

  security.rtkit.enable = true;
  security.sudo.wheelNeedsPassword = false;

  services.blueman.enable = true;
  services.flatpak.enable = true;
  services.fwupd.enable = true;
  services.minidlna = {
    enable = true;
    mediaDirs = [ "/home/upnp-shared/Media" ];
  };
  services.ntp.enable = true;
  services.sshd.enable = true;
  services.tumbler.enable = true;
  services.udisks2.enable = true;
  services.xserver.layout = "us";
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  sound.mediaKeys.enable = true;

  # Localization and Keyboard layout
  time.timeZone = "America/Sao_Paulo";

  system.autoUpgrade.enable = true;
  system.stateVersion = "21.11";
}
