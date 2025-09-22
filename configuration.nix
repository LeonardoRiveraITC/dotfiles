# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
services.udev = {

  packages = with pkgs; [
    qmk
    qmk-udev-rules # the only relevant
    qmk_hid
    via
    vial
  ]; # packages

};
programs.virt-manager.enable = true;
#virtualisation.spiceUSBRedirection.enable = true;
#enable jails
programs.firejail.enable = true;
#disable sleep
systemd.targets.sleep.enable = false;
systemd.targets.suspend.enable = false;
hardware.keyboard.qmk.enable = true;
systemd.targets.hibernate.enable = false;
systemd.targets.hybrid-sleep.enable = false;
#virtualisation.libvirtd.allowedBridges=["virbr0" "bridge2"];
virtualisation.virtualbox.host = {
  enable = false;
  enableKvm = false;
  enableExtensionPack = true;

  enableHardening = true;
  addNetworkInterface = true;
};

systemd.user.services.fanstart = {
  description = "Startfans";
  serviceConfig.User = "root";
  script = ''
  	echo "1" > /sys/class/drm/card0/device/hwmon/hwmon0/pwm1_enable
	echo "128" > /sys/class/drm/card0/device/hwmon/hwmon0/pwm1
  '';
  wantedBy = [ "multi-user.target" ]; # starts after login
};

networking.nftables.enable = true;
#enable docker
virtualisation.docker.enable = true;
virtualisation.docker.rootless = {
  enable = true;
  setSocketVariable = true;
};
users.extraGroups.docker.members = [ "andb" ];
#enable wireshark
programs.wireshark.enable=true;
#enable memtest
boot.loader.grub.memtest86.enable=true;
#enable for amdgpu graphic card
#services.xserver.videoDrivers = [ "amdgpu" ];
#enable steam
programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
};
###
boot.loader.grub.devices=["/dev/sda"];
boot.loader.grub.enable=true;
networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
networking.networkmanager.enable = true;

  # Set your time zone.
time.timeZone = "America/Mexico_City";

  # Select internationalisation properties.
i18n.defaultLocale = "en_US.UTF-8";
virtualisation.libvirtd.enable = true;
programs.dconf.enable = true;

nix.settings.experimental-features = [ "nix-command" "flakes" ];
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


 # xdg.portal.enable = true;
 # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Configure keymap in X11
  services.xserver = {
   layout = "us";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "la-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  programs.adb.enable = true;
    services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };
   
    displayManager = {
        defaultSession = "none+i3";
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
     ];
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.andb = {
    isNormalUser = true;
    description = "andb";
    extraGroups = [ "vboxusers" "docker" "libvirtd" "wireshark" "adbusers" "networkmanager" "wheel" ];
    packages = with pkgs; [	
      picom
      wireshark
      libgcrypt
      vscodium
      glibc_multi
      qemu_kvm
      libvirt
      qemu
      ripgrep
      gscreenshot
      nodejs_18
      libgccjit	
      tmux
      git
      feh
      terminator
      firefox
      i3
      dmenu
      obsidian
      neovim
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
  ];

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
  system.stateVersion = "23.11"; # Did you read the comment?



}
