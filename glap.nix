# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:



{
#enable database
#enable pkgs for intel gpus
  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    libvdpau-va-gl
    intel-media-driver
  ];
#enable adb for non privileged users
	programs.adb.enable = true;
	nix.settings.experimental-features = [ "nix-command" "flakes" ];
#enable i3
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
				i3status # gives you the default i3 status bar
					i3lock #default i3 screen locker
					i3blocks #if you are planning on using i3blocks over i3status
			];
		};
	};

#enable gnome
#services.xserver.enable = true;
#services.xserver.displayManager.gdm.enable = true;
#services.xserver.desktopManager.gnome.enable = true;
#enable vbox
	virtualisation.virtualbox.host.enableExtensionPack = true;
	virtualisation.virtualbox.host.enable = true;
	virtualisation.libvirtd.enable = true;
	virtualisation.virtualbox.guest.enable = true;
	virtualisation.virtualbox.guest.x11 = true;
	programs.dconf.enable = true;
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
	time.timeZone = "America/Mexico_City";

# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";

# Enable the X11 windowing system.
#services.xserver.enable = true;

# Enable the GNOME Desktop Environment.
# services.xserver.displayManager.gdm.enable = true;
# services.xserver.desktopManager.gnome.enable = true;

# Configure keymap in X11
	services.xserver = {
		layout = "latam";
		xkbVariant = "";
	};

# Configure console keymap
	console.keyMap = "la-latin1";

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

# Enable touchpad support (enabled default in most desktopManager).
# services.xserver.libinput.enable = true;

# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.andb = {
		isNormalUser = true;
		description = "andb";
		extraGroups = ["adbusers" "networkmanager" "wheel" "libvirtd" "user-with-access-to-virtualbox" ];
		packages = with pkgs; [
			cowsay
				libva
				rofi
				brightnessctl
				vscodium
				podman
				dolphin
				gscreenshot
				glibc_multi
				qemu_kvm
				libvirt
				qemu
				virt-manager
				tmux
#firefox
				firefox-devedition
				neovim
				polybar
				feh
				nodejs
				gdb
				gcc
				git	
				terminator
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

	networking.firewall = { allowedTCPPorts = [ 20 21 ];
#                        connectionTrackingModules = [ "ftp" ];
	};

	services.vsftpd = {
		enable = true;
#   cannot chroot && write
#    chrootlocalUser = true;
		writeEnable = true;
		localUsers = true;
		userlist = [ "andb" ];
		userlistEnable = true;
	};
	services.vsftpd.extraConfig = ''
		pasv_enable=Yes
		pasv_min_port=51000
		pasv_max_port=51999
		'';
	networking.firewall.allowedTCPPortRanges = [ { from = 51000; to = 51999; } ];

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
	system.stateVersion = "23.05"; # Did you read the comment?

}
