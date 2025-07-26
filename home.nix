{ config, pkgs, ... }:

{
  home.username = "es";
  home.homeDirectory = "/Users/es";
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;
  home.file.".gitconfig".source = ./confs/gitconfig;
  home.file.".rgignore".source = ./confs/rgignore;
  home.file.".tmux.conf".source = ./confs/tmux.conf;
  home.file.".bin/zsh-kubectl-prompt".source = builtins.fetchGit {
    url = "https://github.com/superbrothers/zsh-kubectl-prompt";
    rev = "eb31775d6196d008ba2a34e5d99fb981b5b3092d";
  };
  home.file.".config/base16-shell" = {
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "tinted-theming";
      repo = "base16-shell";
      rev = "bcd9960803c39eb7af30a2db80b57ebd74073bd5";
      sha256 = "sha256-d5llHMl6qczxFodhjfBAkrJVYsurRVf1X1Ks5wFYxd8=";
    };
  };
  home.file.".tmux/plugins/tpm" = {
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tpm";
      rev = "99469c4a9b1ccf77fade25842dc7bafbc8ce9946";
      sha256 = "sha256-hW8mfwB8F9ZkTQ72WQp/1fy8KL1IIYMZBtZYIwZdMQc=";
    };
  };

  xdg.configFile."nvim/init.lua".source = ./vim/init.lua;
  xdg.configFile = {
    "nvim/lua" = {
      source = ./vim/lua;
      recursive = true;
    };
  };
  xdg.configFile = {
    "nvim/snippets" = {
      source = ./vim/snippets;
      recursive = true;
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    fileWidgetCommand = "fd --type f -E=node_modules";
    changeDirWidgetCommand = "fd --type d -E=node_modules";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion = {
      enable = true;
    };
    history.extended = true;
    initContent = ''
      ${builtins.readFile ./confs/zshrc}
      ${builtins.readFile ./confs/zsh_plugin_confs}
      eval "$(starship init zsh)"
    '';
    sessionVariables = { EDITOR = "vim"; };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "docker"
        "docker-compose"
        "git"
        "brew"
        "history"
        "node"
        "npm"
        "kubectl"
        "bazel"
      ];
    };
    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "bf3ef5588af6d3bf7cc60f2ad2c1c95bca216241";
          sha256 = "sha256-0/YOL1/G2SWncbLNaclSYUz7VyfWu+OB8TYJYm4NYkM=";
        };
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.0";
          sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.8.0";
          sha256 = "sha256-iJdWopZwHpSyYl5/FQXEW7gl/SrKaYDEtTH9cGP7iPo=";
        };
      }
    ];
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    extraPython3Packages = ps: with ps; [ black flake8 ];
    withRuby = true;
    extraPackages = with pkgs; [ fzf gcc ];
  };


  home.packages =
    let
      easy-move-resize = with pkgs; stdenv.mkDerivation {
        pname = "easy-move-resize";
        version = "1.4.2";
        src = fetchzip {
          url = "https://github.com/dmarcotte/easy-move-resize/releases/download/1.4.2/Easy.Move+Resize.app.zip";
          sha256 = "03q7cdfihbmny6y89qb22cprgj7l8bmfgmyf3qi60lbyddsbilcy";
        };
        installPhase = ''
          mkdir -p $out/Applications
          cp -r . $out/Applications/Easy\ Move+Resize.app
        '';
      };
      # search in
      # https://search.nixos.org/packages
    in
    [
      pkgs.luajitPackages.luarocks
      pkgs.htop
      pkgs.eza
      pkgs.fasd
      pkgs.ripgrep
      pkgs.jq
      pkgs.httpie
      pkgs.fd
      pkgs.pv
      pkgs.tldr
      pkgs.diff-so-fancy
      pkgs.difftastic
      pkgs.git-lfs
      pkgs.lsd
      pkgs.delta
      pkgs.duf
      pkgs.choose
      pkgs.sd
      pkgs.gtop
      pkgs.fzf
      pkgs.wget
      pkgs.bat
      pkgs.tmux
      pkgs.ffmpeg
      pkgs.sops
      pkgs.gnupg
      pkgs.direnv
      pkgs.protobuf
      pkgs.nodejs
      pkgs.yarn
      pkgs.go
      pkgs.fontconfig
      pkgs.nerd-fonts.proggy-clean-tt
      pkgs.cmake
      pkgs.ninja
      pkgs.gcc
      pkgs.nil
      pkgs.cargo
      pkgs.starship
      easy-move-resize
    ];
}
