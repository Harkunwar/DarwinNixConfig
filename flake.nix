{
  description = "My Macbook Pro 15 Flake";
  inputs = {
    # Where we get most of our software. Giant mono repo with recipes
    # called derivations that saw how to build software
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # nixos-22-11

    # Manages configs and links them to your home directory
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Controls system level software and settings including fonts
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs: {
    # .mac at the end is my computer name
    darwinConfigurations.mac =
      inputs.darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        pkgs = import inputs.nixpkgs { system = "x86_64-darwin"; };
        modules = [
          ({ pkgs, ... }: {
            # Here goes the darwin preferences and configurations
            # Guide: https://daiderd.com/nix-darwin/manual/index.html
            programs.zsh.enable = true;
            environment.shells = [ pkgs.bash pkgs.zsh ];
            environment.loginShell = pkgs.zsh;
            nix.extraOptions = ''
              experimental-features = nix-command flakes
            '';
            environment.systemPackages = [
              pkgs.coreutils

              # Node JS setup
              pkgs.nodejs
              pkgs.yarn
              pkgs.nodePackages.pnpm

              # Tools
              pkgs.iterm2
              pkgs.helix

              # LSPs
              pkgs.nodePackages.typescript-language-server
              pkgs.nodePackages.vscode-langservers-extracted # HTML, CSS, JSON
              pkgs.nodePackages.bash-language-server
              pkgs.nil
              pkgs.nixpkgs-fmt
            ];
            environment.systemPath = [ "/opt/homebrew/bin" ];
            environment.pathsToLink = [ "/Applications" ];
            system.keyboard.enableKeyMapping = true;
            system.keyboard.remapCapsLockToEscape = true;
            fonts.fontDir.enable = true;
            fonts.fonts = [ (pkgs.nerdfonts.override { fonts = [ "Meslo" "FiraCode" ]; }) ];
            services.nix-daemon.enable = true;
            system.defaults.finder.AppleShowAllExtensions = true;
            system.defaults.finder._FXShowPosixPathInTitle = true;
            system.defaults.dock.autohide = true;
            system.defaults.NSGlobalDomain.AppleShowAllExtensions = true;
            system.defaults.NSGlobalDomain.InitialKeyRepeat = 14;
            system.defaults.NSGlobalDomain.KeyRepeat = 1;
            # For backwards compatibility, don't change
            system.stateVersion = 4;
            homebrew = {
              enable = true;
              caskArgs.no_quarantine = true;
              global.brewfile = true;
              masApps = {};
              casks = [ "amethyst" "raycast" ];
              taps = [ "fujiapple852/trippy" ];
              brews = [ "trippy" ];
            };
          })

          inputs.home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.harkunwar.imports = [
                ({ pkgs, ... }: {
                  # Specify my home-manager configs
                  # Guide: https://nix-community.github.io/home-manager/options.html
                  home.stateVersion = "22.11"; # Don't change this, leave it alone
                  home.packages = [ pkgs.ripgrep pkgs.fd pkgs.curl pkgs.less ];
                  home.sessionVariables = {
                    PAGER = "less";
                    CLICOLOR = 1;
                    EDITOR = "hx";
                  };
                  programs.bat.enable = true;
                  programs.bat.config.theme = "TwoDark";
                  programs.fzf.enable = true;
                  programs.fzf.enableZshIntegration = true;
                  programs.exa.enable = true;
                  programs.git.enable = true;
                  programs.git.userName = "Harkunwar Kochar";
                  programs.git.userEmail = "10580591+Harkunwar@users.noreply.github.com";
                  programs.zsh.enable = true;
                  programs.zsh.enableCompletion = true;
                  programs.zsh.enableAutosuggestions = true;
                  programs.zsh.enableSyntaxHighlighting = true;
                  programs.zsh.shellAliases = { ls = "ls --color=auto -F"; };
                  programs.starship.enable = true;
                  programs.starship.enableZshIntegration = true;
                  home.file.".inputrc".text = ''
                    set show-all-if-ambiguous on
                    set completion-ignore-case on
                    set mark-directories on
                    set mark-symlinked-directories on
                    set match-hidden-files off
                    set visible-stats on
                    set keymap vi
                    set editing-mode vi-insert
                  '';
                })
              ];
            };
          }
        ];
      };
  };
}
