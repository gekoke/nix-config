{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.elementary.suites.desktop;
in
{
  options.elementary.suites.desktop = with types; {
    enable = mkEnableOption "common desktop configuration";
  };

  config = mkIf cfg.enable {
    elementary = {
      desktop.hyprland = enabled;

      programs.kitty = enabled // { enableHotkey = true; };

      hardware = {
        storage = enabled;
        networking = enabled;
        audio = enabled;
      };

      system.keyboard = enabled;
    };
  };
}
