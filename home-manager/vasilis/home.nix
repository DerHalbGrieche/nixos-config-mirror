# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule
    ../common/default.nix
    ./default.nix
    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "vasilis";
    homeDirectory = "/home/vasilis";
    sessionVariables = {
      "XDG_FILE_MANAGER" = "nemo";
      "GTK_USE_PORTAL" = "1";
      "GAMESCOPE_WAYLAND_DISPLAY" = "$WAYLAND_DISPLAY";
    };
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];
  home.packages = with pkgs; [
    vesktop
    comma
    mpv
    font-awesome
    localsend
    nemo-with-extensions
    nemo-fileroller
    nemo-python
    fira-code
    pavucontrol
    jq
    wineWowPackages.waylandFull
    osu-lazer-bin
    ungoogled-chromium
    prismlauncher
    lutris
    winetricks
    umu-launcher
    steamtinkerlaunch
    steam-rom-manager
  ];
  fonts.fontconfig.enable = true;
  services.arrpc.enable = true;
  # Enable home-manager and git

  programs.git.enable = true;
  programs.fish = {
    enable = true;
    shellAliases = {
      ssh = "kitten ssh";
      arun = ", appimage-run";
    };
  };
  xdg.enable = true;
  xdg.mimeApps.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
