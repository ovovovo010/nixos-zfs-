{ pkgs, config, lib, ... }:
{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 36;
        spacing = 4;
        margin-top = 8;
        margin-left = 12;
        margin-right = 12;

        "modules-left"   = [ "hyprland/workspaces" "custom/launcher" ];
        "modules-center" = [ "clock" ];
        "modules-right"  = [ "pulseaudio" "network" "bluetooth" "tray" ];

        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            default = "●";
            active  = "◉";
            urgent  = "○";
          };
          on-scroll-up   = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };

        "custom/launcher" = {
          format = "";
          on-click = "rofi -show drun";
          tooltip = false;
        };

        clock = {
          format = " {:%H:%M}";
          format-alt = " {:%a %d %b}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟";
          format-icons = {
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
          on-click = "pavucontrol";
          tooltip = false;
        };

        network = {
          format-wifi      = "󰤨 {essid}";
          format-ethernet  = "󰈀 {ifname}";
          format-disconnected = "󰤭";
          tooltip-format   = "{ipaddr} via {gwaddr}";
          on-click         = "nm-connection-editor";
        };

        bluetooth = {
          format           = "󰂯 {status}";
          format-connected = "󰂱 {device_alias}";
          format-off       = "󰂲";
          on-click         = "blueman-manager";
          tooltip-format   = "{controller_alias}\n{num_connections} connected";
        };

        tray = {
          spacing = 8;
        };
      };
    };

    style = ''
      * {
        font-family: 'JetBrains Mono', monospace;
        font-size: 13px;
        min-height: 0;
        border: none;
        border-radius: 0;
      }

      window#waybar {
        background-color: alpha(#1e1e2e, 0.92);
        color: #cdd6f4;
        border-radius: 12px;
        border: 1px solid #313244;
      }

      #workspaces button {
        padding: 0 7px;
        color: #6c7086;
        background: transparent;
        border-radius: 6px;
        transition: all 0.15s ease;
      }

      #workspaces button.active {
        color: #cba6f7;
        background: #313244;
      }

      #workspaces button.urgent {
        color: #f38ba8;
      }

      #workspaces button:hover {
        color: #cdd6f4;
        background: #45475a;
      }

      #custom-launcher {
        color: #cba6f7;
        padding: 0 10px;
        font-size: 16px;
      }

      #custom-launcher:hover {
        color: #f5c2e7;
      }

      #clock {
        color: #89b4fa;
        font-weight: bold;
        padding: 0 14px;
      }

      #pulseaudio,
      #network,
      #bluetooth,
      #tray {
        padding: 0 9px;
        background: transparent;
      }

      #pulseaudio {
        color: #a6e3a1;
      }

      #pulseaudio.muted {
        color: #6c7086;
      }

      #network {
        color: #89dceb;
      }

      #network.disconnected {
        color: #f38ba8;
      }

      #bluetooth {
        color: #89b4fa;
      }

      #bluetooth.off {
        color: #6c7086;
      }

      #tray {
        padding: 0 6px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: #f38ba8;
        border-radius: 4px;
      }
    '';
  };
}
