{ config
, lib
, pkgs
, inputs
, user
, location
, ...
}: {
  modules = {
    loginmanagers.lightdm.enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "22.05";

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = "experimental-features = nix-command flakes";
    settings = {
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 10d";
    };
  };

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
  };

  swapDevices = [ ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        devices = [ "nodev" ];
        useOSProber = true;
        gfxmodeEfi = "1920x1080";
      };
    };
  };

  # Set timezone automatically using network
  services.tzupdate.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    xserver = {
      enable = true;
      libinput.enable = true;
      windowManager.awesome.enable = true;
    };
    gnome.gnome-keyring.enable = true;
  };

  programs.dconf.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  environment.extraInit = ''
    # Do not want this in the environment. NixOS always sets it and does not
    # provide any option not to, so I must unset it myself via the
    # environment.extraInit option.
    unset -v SSH_ASKPASS
  '';

  networking = {
    hostName = "sol";
    networkmanager.enable = true;
  };
}