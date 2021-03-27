# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Allow unfree proprietary stuff
  nixpkgs.config.allowUnfree = true;
  #nixpkgs.overlays = [
  #    (self: super: {
  #         julia-stable = super.julia.override {
  #              version = "1.6.0";
  #              src_sha256 = "463b71dc70ca7094c0e0fd6d55d130051a7901e8dec5eb44d6002c57d1bd8585";
  #         };
  #    })
  #];
  
  nix = {
    package = pkgs.nixUnstable;
    distributedBuilds = true;
    extraOptions = ''
        experimental-features = nix-command flakes ca-references
        builders-use-substitutes = true
		'';
  };
  nix.trustedUsers = [ "tricks" ];

  # Use the grub-boot EFI boot loader.
  boot = {
    loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = false;
    };
  };  
  fileSystems = {
     "/archlinux" = {
     	device = "/dev/sda1";
	fsType = "ext4";
	label = "archlinux";
	options = [ "defaults" ];
     };
     
  };
  swapDevices = [{
    device = "/var/waspsting";
    size = 2048 * 3;
  }]; 

  networking.hostName = "nixos"; # Define your hostname.
  networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Asia/Manila";

  # Networking
  #

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp3s0f2.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
   font = "Lat2-Terminus16";
   keyMap = "us";
  };

  # Enable the X11 windowing system.
  services = {
    xserver = {
    	enable = true;
        layout = "us";
        libinput.enable = true;
        desktopManager = {
          xterm.enable = false;
	  xfce.thunarPlugins = with pkgs; [ 
	  	xfce.thunar-archive-plugin
		xfce.thunar-volman
		];
        };
        windowManager = {
          i3 = {
            package = pkgs.i3-gaps;
            enable = true;
            extraPackages = with pkgs; [
              dmenu
              i3status
              i3lock
              i3blocks
            ];
          };
        };
        displayManager.lightdm.enable = true;
        displayManager.lightdm.greeters.gtk.enable = true;
    };
    printing.enable = false;
    pipewire = {
        enable = true;
        socketActivation = true;
	pulse.enable = true;
	alsa.enable = true;
	# sessionManager = "${pkgs.pipewire}/bin/pipewire-media-session";
    };
    openssh.enable = true;
  };  
  

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;
  hardware.acpilight.enable = true;
  services.blueman.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tricks = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "networkmanager" "bluetooth" "lp" ]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      acpilight
      alacritty
      autoconf
      automake
      bash
      bat
      binutils
      bison
      brave
      clipit
      curl
      desktop-file-utils
      discord-canary
      dunst
      electron
      fakeroot
      findutils
      firefox-devedition-bin
      fish
      flameshot
      flex
      git
      gnome3.gedit
      gnome3.networkmanagerapplet
      gnumake
      gnupg
      groff
      gtk3-x11
      htop
      libnotify
      libtool
      lightdm
      lightdm_gtk_greeter
      llvm
      lxappearance
      m4
      neofetch
      networkmanager
      nitrogen
      patch
      pavucontrol
      pipewire
      pipewire
      polkit_gnome
      rust-analyzer
      rustup
      simplescreenrecorder
      spotify
      tealdeer
      texinfo
      vim
      wget
      which
      xarchiver
      xclip
      xfce.thunar
      zoxide
      zsh
    ];
    pathsToLink = [ "libexec" ];
    shells = with pkgs; [ bashInteractive zsh fish ];
    variables = {
      EDITOR = "vim";
      TERM = "alacritty";
      VISUAL = "nvim";
    };

  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs = {
      mtr.enable = true;
      gnupg.agent = {
          enable = true;
          enableSSHSupport = true;
      };
      dconf.enable = true;
      zsh.enable = true;
      fish.enable = true;
      bash.enableCompletion = true;
  };

  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

