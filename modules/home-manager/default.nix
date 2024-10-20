({ pkgs, ... }: {
  # Specify my home-manager configs
  # Guide: https://nix-community.github.io/home-manager/options.html
  home = {
    stateVersion = "24.05";
    packages = with pkgs; [ ripgrep fd curl less gnupg pinentry_mac ];
    sessionVariables = {
      PAGER = "less";
      CLICOLOR = 1;
      EDITOR = "hx";
      DIRENV_LOG_FORMAT = "";
    };
    file = {
      ".inputrc".source = ./dotfiles/inputrc;

      # Helix Config
      ".config/helix/config.toml".source = ./dotfiles/config/helix/config.toml;
      ".config/helix/languages.toml".source = ./dotfiles/config/helix/languages.toml;

      # ASCII Hello Art
      ".config/zsh/hello_ascii.txt".source = ./dotfiles/config/zsh/hello_ascii.txt;
    };
  };
  programs = {
    bat = {
      enable = true;
      config.theme = "TwoDark";
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    eza.enable = true;
    htop = {
      enable = true;
    };
    git = {
      enable = true;
      userName = "Harkunwar Kochar";
      userEmail = "10580591+Harkunwar@users.noreply.github.com";
      delta.enable = true;
      aliases = {
        ph = "push origin head";
        au = "add -u";
        cm = "commit -m";
      };
      signing = {
        key = null;
        signByDefault = true;
      };
    };
    gh = {
      enable = true;
    };
    gpg = {
      enable = false;
    };
    vscode = {
      enable = true;
      enableExtensionUpdateCheck = true;
      enableUpdateCheck = true;
      mutableExtensionsDir = true;
      userSettings = {
        "terminal.integrated.fontFamily" = "FiraCode Nerd Font Mono";
        "workbench.colorTheme" = "Default Dark+ Experimental";
        "workbench.iconTheme" = "vscode-icons";
      };
      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix # Nix
        unifiedjs.vscode-mdx # MDX
        esbenp.prettier-vscode # Prettier
        dbaeumer.vscode-eslint # ESLint
        vscode-icons-team.vscode-icons # VSCode Icons
      ];
    };
    zellij = {
      enable = true;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      prezto.tmux.itermIntegration = true;
      initExtra = ''
        # Mac OS Upgrades break Nix, this will prevent that.
        if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; 
        then
          . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        fi

        echo "$(cat $HOME/.config/zsh/hello_ascii.txt)"
      '';
      shellAliases = {
        ls = "ls --color=auto -F";

        cat = "bat";

        nixswitch = "pushd ~/src/system-config; ./switch.sh; popd;";
        nixbuild = "pushd ~/src/system-config; ./build.sh; ./switch.sh; popd;";
        nixupdate = "pushd ~/src/system-config; ./update.sh; ./switch.sh; popd;";
        nixgarbage = "pushd ~/src/system-config; ./garbage.sh; popd;";
      };
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
    };
  };
})
