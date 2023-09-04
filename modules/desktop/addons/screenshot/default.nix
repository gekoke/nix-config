{ config, lib, pkgs, inputs, ... }:

with lib;
let cfg = config.elementary.desktop.addons.screenshot;
in
{
  options.elementary.desktop.addons.screenshot = {
    enable = mkEnableOption "screenshots";
    hyprlandSupport = mkEnableOption "Hyprland screenshot support";
  };

  config = mkIf cfg.enable {
    elementary.home.packages = [
      (
        if cfg.hyprlandSupport
        then inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
        else abort "only supports Hyprland - set 'hyprlandSupport' module option to true"
      )
    ];

    elementary.desktop.hyprland.extraHomeManagerOptions.extraConfig = ''
      bind = SUPER SHIFT, S, exec, grimblast copy area
    '';
  };
}
