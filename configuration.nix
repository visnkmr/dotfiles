# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  nix-software-center = import (pkgs.fetchFromGitHub {
    owner = "vlinkz";
    repo = "nix-software-center";
    rev = "0.1.2";
    sha256 = "xiqF1mP8wFubdsAQ1BmfjzCgOD3YZf7EGWl9i69FTls=";
  }) {};
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };
  #allow insecure packages
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1v"
  ];
  services.flatpak.enable = true;
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # hardware.nvidia.package = (config.boot.kernelPackages.nvidiaPackages.stable.overrideAttrs {
  #   src = pkgs.fetchurl {
  #     url = "https://download.nvidia.com/XFree86/Linux-x86_64/470.199.02/NVIDIA-Linux-x86_64-470.199.02.run";
  #     sha256 = "1zb8swlb8f1l9l6bya64fwd12pk9z0x1lqj2bg1k5khivw721y7x";
  #   };
  # });
services.xserver = {
    videoDrivers = [ "nvidia" ];
    # export finalized xorg.conf to /etc/X11/xorg.conf
    exportConfiguration = true;
    # config = pkgs.lib.mkOverride 50 (builtins.readFile ./quadmon.conf);
  };

  # Unfortunately, upgrading to nixos 21.11 led to us getting the new 495.44
  # driver, which breaks our configuration (boo NVIDIA). So, we are forced to
  # use the older version (which works perfectly!). The configuration here is
  # taken from this commit
  # https://github.com/NixOS/nixpkgs/commit/f8d38db8d7c995e0e20ab6b4e48cac26c2ef0dfa.
  # The instructions at https://nixos.wiki/wiki/Nvidia led me to this commit.
  hardware.nvidia.package =
    config.boot.kernelPackages.nvidiaPackages.legacy_470;

# services.xserver.videoDrivers = [ “nvidia” ];
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rogerv = {
    isNormalUser = true;
    description = "rogerv";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      kate
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    polybar
    distrobox
    vscode
    rustup
    rust-analyzer
    rustc
    rustfmt
    # rustup
    vscode-extensions.llvm-org.lldb-vscode # for hx
    nix-software-center
    git
    gcc gdb
    mailspring
    wget
    lm_sensors
    jetbrains-toolbox
    microsoft-edge
    fish
    chromium
    github-desktop
    brave
    libayatana-appindicator
    joplin-desktop
  ];

   nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 2d";
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
