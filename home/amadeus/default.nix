{ config, pkgs, nur, lib, home-manager, nix-doom-emacs, ... }:
with pkgs.lib;
let
  modifier = "Mod4";
  modifier2 = "Mod1";
  gtkTheme = "Orchis-Dark";
  iconTheme = "Tela-circle-dark";
  terminal = "${pkgs.alacritty}/bin/alacritty";
  menu = "${pkgs.wofi}/bin/wofi -I --show drun";
  defaultBrowser = "firefox.desktop";
  lock = "~/.config/sway/lock.sh --indicator --indicator-radius 100 --ring-color e40000 --clock";
  zshrc = (import ./zshrc.nix) pkgs "tonotdo";
in {
  imports = [
    (import ./waybar)
    (import ./wofi)
    (import ./emacs)
    (import ./browser)
    (import ./xdg pkgs defaultBrowser iconTheme terminal)
  ];

  home.username = "amadeus";
  home.homeDirectory = "/home/amadeus";

  home.language = {
    base = "en_GB.UTF-8";
    time = "pt_BR.UTF-8";
    monetary = "pt_BR.UTF-8";
    numeric = "pt_BR.UTF-8";
  };

  home.file = {
    ".zshrc".text = zshrc;
    ".anthy".source = ./.anthy;
    "wallpaper.jpg".source = ./wallpaper.jpg;
    "wallpaper2.jpeg".source = ./wallpaper2.jpeg;
  };

  programs.git = {
    enable = true;
    userName = "Gabriel Martins";
    userEmail = "gabrielvilarmartins@gmail.com";
    extraConfig = {
      rerere.enabled = true;
      pull.rebase = true;
      tag.gpgsign = true;
      init.defaultBranch = "master";
      core = {
        excludesfile = "$NIXOS_CONFIG_DIR/scripts/gitignore";
        editor = "${pkgs.vim}/bin/vim";
      };
    };
  };

  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty;
    settings = {
      window.opacity = 0.8;
      font = {
        size = 16;
        normal.family = "scientifica";
        bold.family = "scientifica";
        italic.family = "scientifica";
        bold_italic = {
          family = "scientifica";
          size = 9.0;
        };
      };
      shell.program = "${pkgs.zsh}/bin/zsh";
    };
  };

  programs.aria2.enable = true;

  programs.bat = {
    enable = true;
    # Need to check what is going on here
    # themes = {
    #  monokai = builtins.readFile (pkgs.fetchFromGitHub {
    #    owner = "fnordfish";
    #    repo = "MonokaiMD.tmTheme";
    #    rev = "34ec6dc3c96d8155f4a17e1bd3edf43d27feb344";
    #    sha256 = "1x6kjcf91zvkvbssd922k77xmmi56ik2938rvfcs7y3w09nis3l7";
    #  } + "/MonokaiMD.tmTheme");
    # };
  };

  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; }
    ];
  };

  programs.fish.enable = true;

  programs.command-not-found.enable = true;

  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "qt";
  };

  programs.home-manager.enable = true;

  programs.jq.enable = true;

  programs.lsd = {
    enable = true;
    enableAliases = true;
  };

  programs.man = {
    enable = true;
    generateCaches = true;
  };

  programs.mpv = {
    enable = true;
    config = {
      alang = "jpn,eng";
      slang = "jpn,eng";
      audio-channels = "stereo";
      ytdl-format = "bestvideo[height<=?1440]+bestaudio/best";
    };
  };

  programs.mu.enable = true;

  #programs.nushell.enable = true;

  programs.obs-studio = { enable = true; };

  programs.ssh.enable = true;

  programs.tealdeer.enable = true;

  programs.tmux.enable = true;

  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    #settings = {
    #};
    #style = {
    #};
  };

  programs.zathura.enable = true;

  programs.zsh.oh-my-zsh.enable = true;

  services.mpd-discord-rpc.enable = true;

  services.network-manager-applet.enable = true;

  services.playerctld.enable = true;

  services.swayidle = {
    enable = true;
    #timeouts = {};
  };

  gtk = {
    cursorTheme.name = "Adwaita";
    iconTheme.package = tela-circle-icon-theme;
  };

  home.packages = with pkgs; [
    swaynotificationcenter
    sway-launcher-desktop
    orchis-theme
    tela-circle-icon-theme
    tenacity
    oh-my-zsh
  ];

  xdg.desktopEntries = {
    "discord" = {
      name = "Discord (XWayland)";
      exec = "nowl ${pkgs.discord}/bin/discord";
      terminal = false;
      categories = [ "Application" "Network" ];
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    wrapperFeatures.base = true; # so that gtk works properly
    xwayland = true;
    config = {
      inherit modifier terminal menu;
      floating.modifier = modifier;
      bars = [ ];

      focus = { followMouse = "yes"; };

      keybindings = lib.mkOptionDefault ({
        # Window helpers
        "${modifier}+Shift+f" = "fullscreen toggle global";
        "${modifier}+Shift+t" = "sticky toggle";

        # Volume controls
        "XF86AudioRaiseVolume" = "exec ${pkgs.avizo}/bin/volumectl -u up";
        "XF86AudioLowerVolume" = "exec ${pkgs.avizo}/bin/volumectl -u down";
        "XF86AudioMute" = "exec ${pkgs.avizo}/bin/volumectl toggle-mute";

        # Lightweight screenshot to cliboard and temporary file
        "Print" =
          "exec ${pkgs.grim}/bin/grim -t png -g \"$(${pkgs.slurp}/bin/slurp)\" - | tee /tmp/screenshot.png | ${pkgs.wl-clipboard}/bin/wl-copy -t 'image/png'";

        # Notifications tray
        "${modifier}+Shift+n" =
          "exec ${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";

        # Enter my extra modes
        "${modifier}+c" = "mode command_mode";

        # Navigation Between Workspaces
        "${modifier}+${modifier2}+left" = "workspace prev";
        "${modifier}+${modifier2}+right" = "workspace next";

        # Reload/Restart
        "${modifier}+Shift+c" = "reload";
        "${modifier}+Shift+r" = "restart";

        "${modifier}+${modifier2}+v" = "split v";
        "${modifier}+${modifier2}+h" = "split h";

        # My extra lot of workspaces
        "${modifier}+1" = "workspace 1";
        "${modifier}+2" = "workspace 2";
        "${modifier}+3" = "workspace 3";
        "${modifier}+4" = "workspace 4";
        "${modifier}+5" = "workspace 5";
        "${modifier}+6" = "workspace 6";
        "${modifier}+7" = "workspace 7";
        "${modifier}+8" = "workspace 8";
        "${modifier}+9" = "workspace 9";
        "${modifier}+0" = "workspace 10";
        "${modifier}+${modifier2}+1" = "workspace 11";
        "${modifier}+${modifier2}+2" = "workspace 12";
        "${modifier}+${modifier2}+3" = "workspace 13";
        "${modifier}+${modifier2}+4" = "workspace 14";
        "${modifier}+${modifier2}+5" = "workspace 15";
        "${modifier}+${modifier2}+6" = "workspace 16";
        "${modifier}+${modifier2}+7" = "workspace 17";
        "${modifier}+${modifier2}+8" = "workspace 18";
        "${modifier}+${modifier2}+9" = "workspace 19";
        "${modifier}+${modifier2}+0" = "workspace 20";
        "${modifier}+Shift+1" = "move container to workspace 1";
        "${modifier}+Shift+2" = "move container to workspace 2";
        "${modifier}+Shift+3" = "move container to workspace 3";
        "${modifier}+Shift+4" = "move container to workspace 4";
        "${modifier}+Shift+5" = "move container to workspace 5";
        "${modifier}+Shift+6" = "move container to workspace 6";
        "${modifier}+Shift+7" = "move container to workspace 7";
        "${modifier}+Shift+8" = "move container to workspace 8";
        "${modifier}+Shift+9" = "move container to workspace 9";
        "${modifier}+Shift+0" = "move container to workspace 10";
        "${modifier}+${modifier2}+Shift+1" = "move container to workspace 11";
        "${modifier}+${modifier2}+Shift+2" = "move container to workspace 12";
        "${modifier}+${modifier2}+Shift+3" = "move container to workspace 13";
        "${modifier}+${modifier2}+Shift+4" = "move container to workspace 14";
        "${modifier}+${modifier2}+Shift+5" = "move container to workspace 15";
        "${modifier}+${modifier2}+Shift+6" = "move container to workspace 16";
        "${modifier}+${modifier2}+Shift+7" = "move container to workspace 17";
        "${modifier}+${modifier2}+Shift+8" = "move container to workspace 18";
        "${modifier}+${modifier2}+Shift+9" = "move container to workspace 19";
        "${modifier}+${modifier2}+Shift+0" = "move container to workspace 20";

        "${modifier}+z" = lock;
      });

      window = {
        border = 1;
        titlebar = false;
        hideEdgeBorders = "both";

        commands = [
          {
            criteria = { class = "^.*"; };
            command = "border pixel 1";
          }
          {
            criteria = {
              app_id = "firefox";
              title = "Picture-in-Picture";
            };
            command = "floating enable sticky enable";
          }
          {
            criteria = {
              app_id = "firefox";
              title = "Firefox — Sharing Indicator";
            };
            command = "floating enable sticky enable";
          }
          {
            criteria = { title = "alsamixer"; };
            command = "floating enable border pixel 1";
          }
          {
            criteria = { class = "Clipgrab"; };
            command = "floating enable";
          }
          {
            criteria = { title = "File Transfer*"; };
            command = "floating enable";
          }
          {
            criteria = { class = "bauh"; };
            command = "floating enable";
          }
          {
            criteria = { class = "Galculator"; };
            command = "floating enable border pixel 1";
          }
          {
            criteria = { class = "GParted"; };
            command = "floating enable border normal";
          }
          {
            criteria = { title = "i3_help"; };
            command = "floating enable sticky enable border normal";
          }
          {
            criteria = { class = "Lightdm-settings"; };
            command = "floating enable sticky enable border normal";
          }
          {
            criteria = { class = "Lxappearance"; };
            command = "floating enable border normal";
          }
          {
            criteria = { class = "Pavucontrol"; };
            command = "floating enable";
          }
          {
            criteria = { class = "Pavucontrol"; };
            command = "floating enable";
          }
          {
            criteria = { class = "Qtconfig-qt4"; };
            command = "floating enable border normal";
          }
          {
            criteria = { class = "qt5ct"; };
            command = "floating enable sticky enable border normal";
          }
          {
            criteria = { title = "sudo"; };
            command = "floating enable sticky enable border normal";
          }
          {
            criteria = { class = "Skype"; };
            command = "floating enable border normal";
          }
          {
            criteria = { class = "(?i)virtualbox"; };
            command = "floating enable border normal";
          }
          {
            criteria = { class = "Xfburn"; };
            command = "floating enable";
          }
          {
            criteria = { class = "keepassxc"; };
            command = "floating enable";
          }
          {
            criteria = { instance = "origin.exe"; };
            command = "floating enable";
          }
          {
            criteria = { title = "Slack \\| mini panel"; };
            command = "floating enable; stick enable";
          }
        ];
      };

      floating.criteria = [
        {
          app_id = "firefox";
          title = "moz-extension:.+";
        }
        {
          app_id = "firefox";
          title = "Password Required";
        }
      ];

      fonts = {
        names = [ "scientifica" ];
        size = 8.0;
      };

      input = {
        "*" = {
          xkb_layout = "us";
          xkb_variant = "intl";
          repeat_delay = "1000";
          repeat_rate = "35";
        };
      };

      output = {
        HDMI-1 = {
          background = "~/wallpaper.jpg fill";
          pos = "0 0";
          mode = "1920x1080@75.000000hz";
        };
        DP-2 = {
          background = "~/wallpaper2.jpeg fill";
          pos = "1920 180";
          mode = "1440x900@60.000000hz";
        };
      };

      left = "h";
      right = "l";
      up = "k";
      down = "j";

      modes = lib.mkOptionDefault {
        "command_mode" = {
          "p" = "exec ~/.config/sway/power-menu.sh";
          "o" = "exec ~/.config/sway/projects.sh";
          "Escape" = "mode default";
        };
      };

      startup = [
        {
          command = "${pkgs.swaynotificationcenter}/bin/swaync";
        }
        # { command = "~/.config/waybar/waybar.sh"; }
        { command = "nm-applet --indicator"; }
        {
          command = "clipman";
        }
        # { command = "ibus-daemon -drxr"; }
        # { command = "ibus engine mozc-jp"; }
      ];
    };
    extraConfig = ''
      # Proper way to start portals
      exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP
    '';
    extraSessionCommands = ''
      # Force wayland overall.
      export BEMENU_BACKEND='wayland'
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

      export GTK_THEME='${gtkTheme}'
      export GTK_ICON_THEME='Tela-circle-dark'
      export GTK2_RC_FILES='${pkgs.orchis-theme}/share/themes/${gtkTheme}/gtk-2.0/gtkrc'
      export QT_STYLE_OVERRIDE='gtk2'

      # KDE/Plasma platform for Qt apps.
      export QT_QPA_PLATFORMTHEME='kde'
      export QT_PLATFORM_PLUGIN='kde'
      export QT_PLATFORMTHEME='kde'
    '';
  };
  home.stateVersion = "21.11";
}
