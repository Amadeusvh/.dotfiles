{ pkgs, nur, lib, ... }:
{
  programs.firefox = {
    enable = true;
    profiles = {
      "p" = {
        id = 0;
        name = "p";
        isDefault = true;
        # extensions = with nur.repos.rycee.firefox-addons; [
        #   bitwarden
        # ];
      };
    };
  };

  # Create Firefox .desktop for each profile
  xdg = {
    desktopEntries = {
      "firefox" = {
        name = "Firefox (Wayland)";
        genericName = "Web Browser";
        exec = "${pkgs.firefox}/bin/firefox %U";
        terminal = false;
        icon = "firefox";
        categories = [ "Application" "Network" "WebBrowser" ];
        mimeType = [
          "application/pdf"
          "application/vnd.mozilla.xul+xml"
          "application/xhtml+xml"
          "text/html"
          "text/xml"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
        ];
        type = "Application";
      };
    };
  };
}
