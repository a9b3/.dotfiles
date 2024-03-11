{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    fileWidgetCommand = "fd --type f";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    history.extended = true;
    initExtra = ''
      ${builtins.readFile ./scripts/git-prompt.sh}
      ${builtins.readFile ./confs/zshrc}
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
        file = "fzf-tab.plugin.zsh";
        src = builtins.fetchGit {
          url = "https://github.com/Aloxaf/fzf-tab";
          rev = "220bee396dd3c2024baa54015a928d5915e4f48f";
        };
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.4.0";
          sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        file = "zsh-syntax-highlighting.zsh";
        src = builtins.fetchGit {
          url = "https://github.com/zsh-users/zsh-syntax-highlighting/";
          rev = "932e29a0c75411cb618f02995b66c0a4a25699bc";
        };
      }
    ];
  };

  home.username = "es";
  home.homeDirectory = "/Users/es";
  home.stateVersion = "22.05";

  home.file.".gitconfig".source = ./confs/gitconfig;
  home.file.".rgignore".source = ./confs/rgignore;
  home.file.".tmux.conf".source = ./confs/tmux.conf;
  home.file.".bin/zsh-kubectl-prompt".source = builtins.fetchGit {
    url = "https://github.com/superbrothers/zsh-kubectl-prompt";
    rev = "eb31775d6196d008ba2a34e5d99fb981b5b3092d";
  };
  home.file.".config/nvim/coc-settings.json".source = ./vim/coc-settings.json;
  home.file.".local/share/nvim/site/autoload/plug.vim".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim";
    sha256 = "sha256-uXwLrsgan6PYYfxuddiYE+wrBAdZ3WFo/mUnjyxDne0=";
  };
  home.file.".config/base16-shell" = {
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "chriskempson";
      repo = "base16-shell";
      rev = "588691ba71b47e75793ed9edfcfaa058326a6f41";
      sha256 = "sha256-X89FsG9QICDw3jZvOCB/KsPBVOLUeE7xN3VCtf0DD3E=";
    };
  };
  home.file.".tmux/plugins/tpm" = {
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tpm";
      rev = "b699a7e01c253ffb7818b02d62bce24190ec1019";
      sha256 = "sha256-aGRy5ah1Dxb+94QoIkOy0nKlmAOFq2y5xnf2B852JY0";
    };
  };

  home.packages = let
    easy-move-resize = with pkgs; stdenv.mkDerivation rec {
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
  in [
    pkgs.htop
    pkgs.eza
    pkgs.fasd
    pkgs.ripgrep
    pkgs.jq
    pkgs.httpie
    pkgs.fd
    pkgs.diff-so-fancy
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
    pkgs.proggyfonts
    easy-move-resize
  ];

  fonts.fontconfig.enable = true;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    extraPython3Packages = ps: with ps; [ black flake8 ];
    withRuby = true;
    extraConfig = builtins.readFile ./vim/init.vim;
    extraPackages = with pkgs; [ fzf ];
  };
}
