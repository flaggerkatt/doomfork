{ config, options, lib, pkgs, ... }:
with lib;
{
  imports = [
    ./common.nix
  ];

  options.modules.desktop.bspwm = {
    enable = mkOption { type = types.bool; default = false; };
  };

  config = mkIf config.modules.desktop.bspwm.enable {
    environment.systemPackages = with pkgs; [
      lightdm
      dunst
      libnotify
      (polybar.override {
        pulseSupport = true;
        nlSupport = true;
      })
    ];

    services = {
      compton.enable = true;
      redshift.enable = true;
      xserver = {
        enable = true;
        displayManager.lightdm.enable = true;
        displayManager.lightdm.greeters.mini.enable = true;
        windowManager.default = "bspwm";
        windowManager.bspwm.enable = true;
      };
    };

    # link recursively so other modules can link files in their folders
    my.home.xdg.configFile = {
      "sxhkd".source = <config/sxhkd>;
      "bspwm" = {
        source = <config/bspwm>;
        recursive = true;
      };
    };
  };
}
