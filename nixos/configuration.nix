# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  hardware.bluetooth.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://127.0.0.1:7890/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  
  nix.settings = {
    ssl-cert-file = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    experimental-features = [ 
	"nix-command" 
	"flakes"
    ];
    substituters = [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
    download-buffer-size = 524288000;
  };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-fluent
      (fcitx5-rime.override {
        rimeDataPkgs = [
          pkgs.rime-ice
        ];
      })
    ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
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
  users.users.levy = {
    isNormalUser = true;
    description = "levy";
    extraGroups = [ "networkmanager" "wheel" "audio"];
    shell = pkgs.fish;
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  
  programs.niri.enable = true;

  programs.fish.enable = true;

  programs.dms-shell = {
    enable = true;
    # systemd = {
    #   enable = true;
    #   restartIfChanged = true;
    # };
    enableSystemMonitoring = true;
    enableClipboard = true;
    enableVPN = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
    
  };

  programs.dsearch = {
    enable = true;

    systemd = {
      enable = true;
      target = "default.target";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.swaylock = {};

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     git
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     alacritty fuzzel swaylock mako swayidle sway
     hyprpanel
     stow
     zoxide
     tmux   
     uv
     tree
     yazi
     helix
     eza
     clipboard-jh
     jjui
     neofetch
     starship
     jujutsu
     btop
     busybox
     docker
     clash-rs
     croc
     zed-editor
     navi
     fzf
     ripgrep
     fd
     gemini-cli
     fnm
     atuin
     neofetch
     microsoft-edge
     opencode
     obsidian
     rustup
     mininet
     # clash-verge-rev pkg-config dbus openssl_3 glib gtk3 libsoup_2_4 webkitgtk appimagekit librsvg
     clashtui
     v2rayn
     samba
  ];
  fonts = {
    packages = with pkgs; [
       nerd-fonts.hack
       nerd-fonts.jetbrains-mono# JetBrainsMono Nerd Font（JetBrains官方，颜值高）
       nerd-fonts.fira-code      # FiraCode Nerd Font（连字友好，适合前端/Go）
       nerd-fonts.meslo-lg       # MesloLG Nerd Font（终端/Oh My Zsh 标配）
       adwaita-fonts
       noto-fonts-color-emoji
       nerd-fonts.symbols-only
       # 以上三个几乎是必须安装的
       noto-fonts-cjk-sans
       noto-fonts-cjk-serif
    ];
    # 2. 关键：启用字体自动缓存（NixOS必加，否则字体不生效）
    fontDir.enable = true;
  };
  
  virtualisation.docker.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
 
  services = {
    displayManager = {
      dms-greeter = {
        enable = true;
        compositor.name = "niri";
      };
    };
    mihomo = {
      enable = true;
      configFile = "/home/levy/.dotfiles/mihomo/config.yaml";
    };
  };

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
  system.stateVersion = "25.05"; # Did you read the comment?

}
