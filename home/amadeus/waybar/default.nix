{ config, pkgs, lib, ... }:
let
    hostName = builtins.getEnv "HOSTNAME";
    desktopHostname = "maxhero-workstation";
    batteryComponent = ''
    "custom/left-arrow-dark",
    "battery",
    "custom/left-arrow-light",
    '';
    battery = if (hostName == desktopHostname) then batteryComponent else "";
    fontSize = if (hostName == desktopHostname) then 24 else 16;
    waybar = "${pkgs.waybar}/bin/waybar";
in
{
    xdg.configFile."waybar/config".text = ''
        {
            "layer": "top",
            "position": "top",
            "modules-left": [
                "sway/workspaces",
                "custom/right-arrow-dark"
            ],
            "modules-center": [
                "custom/left-arrow-dark",
                "clock#1",
                "custom/left-arrow-light",
                "custom/left-arrow-dark",
                "clock#2",
                "custom/right-arrow-dark",
                "custom/right-arrow-light",
                "clock#3",
                "custom/right-arrow-dark"
            ],
            "modules-right": [
                "custom/left-arrow-dark",
                "pulseaudio",
                "custom/left-arrow-light",
                "custom/left-arrow-dark",
                "memory",
                "custom/left-arrow-light",
                "custom/left-arrow-dark",
                "cpu",
                "custom/left-arrow-light",
                "custom/left-arrow-dark",
                "disk",
                "custom/left-arrow-light",
                ${battery}
                "custom/left-arrow-dark",
                "tray"
            ],
            "custom/events": {
                "format": "{}",
                "tooltip": true,
                "interval": 300,
                "format-icons": {
                "default": ""
                },
                "exec": "waybar-khal.py",
                "return-type": "json"
            },
            "custom/weather": {
                "format": "{}",
                "tooltip": true,
                "interval": 3600,
                "exec": "waybar-wttr.py",
                "return-type": "json"
            },
            "custom/gpu-usage": {
            "exec": "radeontop -d --limit 1 -i 4 - | cut -c 32-35 -",
            "format": "GPU {}%",
            "tooltip": false,
            "return-type": "",
            "interval": 4
            },
            "custom/left-arrow-dark": {
                "format": "",
                "tooltip": false
            },
            "custom/left-arrow-light": {
                "format": "",
                "tooltip": false
            },
            "custom/right-arrow-dark": {
                "format": "",
                "tooltip": false
            },
            "custom/right-arrow-light": {
                "format": "",
                "tooltip": false
            },

            "sway/workspaces": {
                "disable-scroll": false,
                "format": "{icon}",
                "format-icons": {
                        "1": "一",
                        "2": "二",
                        "3": "三",
                        "4": "四",
                        "5": "五",
                        "6": "六",
                        "7": "七",
                        "8": "八",
                        "9": "九",
                        "10": "十",
                        "11": "十一",
                        "12": "十二",
                        "13": "十三",
                        "14": "十四",
                        "15": "十五",
                        "16": "十六",
                        "17": "十七",
                        "18": "十八",
                        "19": "十九",
                        "20": "二十",
                        "21": "二十一",
                        "22": "二十二",
                        "23": "二十三",
                        "24": "二十四",
                        "25": "二十五",
                        "26": "二十六",
                        "27": "二十七",
                        "28": "二十八",
                        "29": "二十九",
                        "30": "三十",
                        "31": "三十一",
                        "32": "三十二",
                        "33": "三十三",
                        "34": "三十四",
                        "35": "三十五",
                        "36": "三十六",
                        "37": "三十七",
                        "38": "三十八",
                        "39": "三十九",
                        "40": "四十",
                        "41": "四十一",
                        "42": "四十二",
                        "43": "四十三",
                        "44": "四十四",
                        "45": "四十五",
                        "46": "四十六",
                        "47": "四十七",
                        "48": "四十八",
                        "49": "四十九",
                        "50": "五十",
                        "51": "五十一",
                        "52": "五十二",
                        "53": "五十三",
                        "54": "五十四",
                        "55": "五十五",
                        "56": "五十六",
                        "57": "五十七",
                        "58": "五十八",
                        "59": "五十九",
                        "60": "六十",
                        "61": "六十一",
                        "62": "六十二",
                        "63": "六十三",
                        "64": "六十四",
                        "65": "六十五",
                        "66": "六十六",
                        "67": "六十七",
                        "68": "六十八",
                        "69": "六十九",
                        "70": "七十",
                        "71": "七十一",
                        "72": "七十二",
                        "73": "七十三",
                        "74": "七十四",
                        "75": "七十五",
                        "76": "七十六",
                        "77": "七十七",
                        "78": "七十八",
                        "79": "七十九",
                        "80": "八十",
                        "81": "八十一",
                        "82": "八十二",
                        "83": "八十三",
                        "84": "八十四",
                        "85": "八十五",
                        "86": "八十六",
                        "87": "八十七",
                        "88": "八十八",
                        "89": "八十九",
                        "90": "九十",
                        "91": "九十一",
                        "92": "九十二",
                        "93": "九十三",
                        "94": "九十四",
                        "95": "九十五",
                        "96": "九十六",
                        "97": "九十七",
                        "98": "九十八",
                        "99": "九十九",
                        "100": "百"
                }
            },

            "clock#1": {
                "format": "{:%a}",
                "tooltip": false
            },
            "clock#2": {
                "format": "{:%H:%M}",
                "tooltip": false
            },
            "clock#3": {
                "format": "{:%y-%m-%d}",
                "tooltip": false
            },

            "pulseaudio": {
                "format": "{icon} {volume:2}%",
                "format-bluetooth": "{icon}  {volume}%",
                "format-muted": "MUTE",
                "format-icons": {
                    "headphones": "",
                    "default": [
                        "",
                        ""
                    ]
                },
                "scroll-step": 5,
                "on-click": "pamixer -t",
                "on-click-right": "pavucontrol"
            },
            "memory": {
                //"interval": 5,
                //"format": "Mem {}%"
                "interval": 30,
                "format": "{used:0.1f}G/{total:0.1f}G "
            },
            "cpu": {
                "interval": 5,
                "format": "CPU {usage:2}%"
            },
            "battery": {
                "states": {
                    "good": 95,
                    "warning": 30,
                    "critical": 15
                },
                "format": "{icon} {capacity}%",
                "format-icons": [
                    "",
                    "",
                    "",
                    "",
                    ""
                ]
            },
            "disk": {
                "interval": 5,
                "format": "Disk {percentage_used:2}%",
                "path": "/"
            },
            "tray": {
                "icon-size": 24
            }
        }
    '';
    xdg.configFile."waybar/modules".source = ./modules;

    programs.waybar.enable = true;
    programs.waybar.style = ''
    * {
        font-size: ${toString fontSize}px;
        font-family: scientifica, dina;
    }

    window#waybar {
        background: #303030;
        color: #fdf6e3;
    }

    #custom-right-arrow-dark,
    #custom-left-arrow-dark {
        color: #1a1a1a;
    }
    #custom-right-arrow-light,
    #custom-left-arrow-light {
        color: #292b2e;
        background: #101010;
    }

    #workspaces,
    #clock.1,
    #clock.2,
    #clock.3,
    #pulseaudio,
    #custom-gpu-usage,
    #custom-weather,
    #custom-events,
    #memory,
    #cpu,
    #battery,
    #disk,
    #tray {
        background: #101010;
    }

    #workspaces button {
        padding: 0 2px;
        color: #fdf6e3;
    }
    #workspaces button.focused {
        color: #268bd2;
    }
    #workspaces button:hover {
        box-shadow: inherit;
        text-shadow: inherit;
    }
    #workspaces button:hover {
        background: #101010;
        border: #1a1a1a;
        padding: 0 4px;
    }

    #pulseaudio {
        color: #268bd2;
    }

    #custom-gpu-usage {
        color: #00ff00;
    }

    #memory {
        color: #2aa198;
    }
    #cpu {
        color: #6c71c4;
    }
    #battery {
        color: #859900;
    }
    #disk {
        color: #b58900;
    }

    #clock,
    #pulseaudio,
    #memory,
    #cpu,
    #battery,
    #disk {
        padding: 4px 16px;
    }
    '';

    xdg.configFile."waybar.sh" = {
        text = ''
        #!/usr/bin/env bash
        # Terminate already running bar instances
        killall -q ${waybar}
        killall -q .waybar-wrapped
        
        # Wait until the processes have been shut down
        while pgrep -x ${waybar} >/dev/null; do sleep 1; done
        # Launch main
        ${waybar}
        '';
        executable = true;
    };

    xdg.configFile."waybar/mediaplayer.py" = {
        source = ./mediaplayer.py;
        executable = true;
    };

    xdg.configFile."waybar/waybar-khal.py" = {
        source = ./waybar-khal.py;
        executable = true;
    };

    xdg.configFile."waybar/waybar-wttr.py" = {
        source = ./waybar-wttr.py;
        executable = true;
    };
}
