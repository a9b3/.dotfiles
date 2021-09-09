{ config, pkgs, ... }:

{
  # Get overlay for neovim-nightly
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];
  programs.home-manager.enable = true;
  programs.alacritty.enable = true;
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
      ${builtins.readFile ./git-prompt.sh}
      ${builtins.readFile ./zshrc}
    '';
    sessionVariables = rec {
      EDITOR = "vim";
    };
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
      ];
    };
    plugins = [
      {
        # will source zsh-autosuggestions.plugin.zsh
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

  # ---------------------------------------------------------
  # Managed files
  # ---------------------------------------------------------
  home.file.".alacritty.yml".source = ./alacritty.yml;
  home.file.".gitconfig".source = ./gitconfig;
  home.file.".rgignore".source = ./rgignore;
  home.file.".config/nvim/coc-settings.json".source = ./vim/coc-settings.json;
  home.file.".local/share/nvim/site/autoload/plug.vim".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim";
    sha256 = "1gpldpykvn9sgykb1ydlwz0zkiyx7y9qhf8zaknc88v1pan8n1jn";
  };
  home.file.".config/base16-shell" = {
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "chriskempson";
      repo = "base16-shell";
      rev = "ce8e1e540367ea83cc3e01eec7b2a11783b3f9e1";
      sha256 = "1yj36k64zz65lxh28bb5rb5skwlinixxz6qwkwaf845ajvm45j1q";
    };
  };

  home.packages = [
    # SYSTEM
    pkgs.htop
    pkgs.exa
    pkgs.fasd
    pkgs.ripgrep
    pkgs.jq
    pkgs.httpie
    pkgs.fd
    pkgs.diff-so-fancy
    pkgs.docker
    pkgs.youtube-dl
    pkgs.fzf
    pkgs.wget
    pkgs.bat

    # NODE
    pkgs.nodejs
    pkgs.yarn

    # GOLANG
    pkgs.go

    # FONTS
    pkgs.fontconfig
    pkgs.proggyfonts
  ];

  fonts.fontconfig.enable = true;

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    extraPython3Packages = (ps: with ps; [
      black
      flake8
    ]);
    withRuby = true;
    extraConfig = builtins.readFile ./vim/init.vim;
    extraPackages = with pkgs; [
      pkgs.fzf
    ];
    plugins = with pkgs.vimPlugins; let
      # ap/vim-buftabline
      buftabline = pkgs.vimUtils.buildVimPlugin {
        name = "buftabline";
        src = pkgs.fetchFromGitHub {
          owner = "ap";
          repo = "vim-buftabline";
          rev = "73b9ef5dcb6cdf6488bc88adb382f20bc3e3262a";
          sha256 = "1vs4km7fb3di02p0771x42y2bsn1hi4q6iwlbrj0imacd9affv5y";
        };
        dontBuild = true;
        installPhase = ''
          mkdir -p $out
          cp -r ./ $out
        '';
      };
      vim-agriculture = pkgs.vimUtils.buildVimPlugin {
        name = "vim-agriculture";
        src = pkgs.fetchFromGitHub {
          owner = "jesseleite";
          repo = "vim-agriculture";
          rev = "1095d907930fc545f88541b14e5ea9e34d63c40f";
          sha256 = "11xkiqm26y9szmh1isgvdlycblb9y651q6amws26il96a5kf346s";
        };
        dontBuild = true;
        installPhase = ''
          mkdir -p $out
          cp -r ./ $out
        '';
      };
      nerdtree-buffer-ops = pkgs.vimUtils.buildVimPlugin {
        name = "nerdtree-buffer-ops";
        src = pkgs.fetchFromGitHub {
          owner = "PhilRunninger";
          repo = "nerdtree-buffer-ops";
          rev = "bd0cd6bd6db38d1641d24fc5d4c65e066eb0781b";
          sha256 = "0hfs08jlwkkficlkyzscbbzqxink6qmps4ca70q9zmq121y1yzlj";
        };
        dontBuild = true;
        installPhase = ''
          mkdir -p $out
          cp -r ./ $out
        '';
      };
      vim-diff-enhanced = pkgs.vimUtils.buildVimPlugin {
        name = "vim-diff-enhanced";
        src = pkgs.fetchFromGitHub {
          owner = "chrisbra";
          repo = "vim-diff-enhanced";
          rev = "c6d4404251206fbb21ef6524b8a24d859097e689";
          sha256 = "0ixhbcmih8r1sjzj3hy8jl6wz7ip0xz72q0682i2vlccgx0bm92a";
        };
        dontBuild = true;
        installPhase = ''
          mkdir -p $out
          cp -r ./ $out
        '';
      };
      vim-hclfmt = pkgs.vimUtils.buildVimPlugin {
        name = "vim-hclfmt";
        src = pkgs.fetchFromGitHub {
          owner = "fatih";
          repo = "vim-hclfmt";
          rev = "1f3caf11253af6870451eb2af35b5616809cbc80";
          sha256 = "1w4naprdf2g5i7r9d200kvxcqaqs6538g45jdn45vvxfbj4sfsfl";
        };
        dontBuild = true;
        installPhase = ''
          mkdir -p $out
          cp -r ./ $out
        '';
      };
      Vim-Jinja2-Syntax = pkgs.vimUtils.buildVimPlugin {
        name = "Vim-Jinja2-Syntax";
        src = pkgs.fetchFromGitHub {
          owner = "Glench";
          repo = "Vim-Jinja2-Syntax";
          rev = "2c17843b074b06a835f88587e1023ceff7e2c7d1";
          sha256 = "13mfzsw3kr3r826wkpd3jhh1sy2j10hlj1bv8n8r01hpbngikfg7";
        };
        dontBuild = true;
        installPhase = ''
          mkdir -p $out
          cp -r ./ $out
        '';
      };
      html5.vim = pkgs.vimUtils.buildVimPlugin {
        name = "html5.vim";
        src = pkgs.fetchFromGitHub {
          owner = "othree";
          repo = "html5.vim";
          rev = "7c9f6f38ce4f9d35db7eeedb764035b6b63922c6";
          sha256 = "1hgbvdpmn3yffk5ahz7hz36a7f5zjc1k3pan5ybgncmdq9f4rzq6";
        };
        dontBuild = true;
        installPhase = ''
          mkdir -p $out
          cp -r ./ $out
        '';
      };
      # evanleck/vim-svelte/archive/5f88e5a0fe7dcece0008dae3453edbd99153a042
      vim-mustache-handlebars = pkgs.vimUtils.buildVimPlugin {
        name = "vim-mustache-handlebars";
        src = pkgs.fetchFromGitHub {
          owner = "mustache";
          repo = "vim-mustache-handlebars";
          rev = "fcc1401c2f783c14314ef22517a525a884c549ac";
          sha256 = "01nkd89dzjw8cqs2zv7hwwgljxs53dxqfv774kswmz5g198vxf7d";
        };
        dontBuild = true;
        installPhase = ''
          mkdir -p $out
          cp -r ./ $out
        '';
      };
      vim-jsx = pkgs.vimUtils.buildVimPlugin {
        name = "vim-jsx";
        src = pkgs.fetchFromGitHub {
          owner = "mxw";
          repo = "vim-jsx";
          rev = "8879e0d9c5ba0e04ecbede1c89f63b7a0efa24af";
          sha256 = "0czjily7kjw7bwmkxd8lqn5ncrazqjsfhsy3sf2wl9ni0r45cgcd";
        };
        dontBuild = true;
        installPhase = ''
          mkdir -p $out
          cp -r ./ $out
        '';
      };
      yajs-vim = pkgs.vimUtils.buildVimPlugin {
        name = "yajs-vim";
        src = pkgs.fetchFromGitHub {
          owner = "othree";
          repo = "yajs.vim";
          rev = "2bebc45ce94d02875803c67033b2d294a5375064";
          sha256 = "15ky34nbv0wa9jq92hm7ya4s05zgippkcifd3m8s59n0dy5lkpc0";
        };
        dontBuild = true;
        installPhase = ''
          mkdir -p $out
          cp -r ./ $out
        '';
      };
      vim-svelte = pkgs.vimUtils.buildVimPlugin {
        name = "vim-svelte";
        src = pkgs.fetchFromGitHub {
          owner = "evanleck";
          repo = "vim-svelte";
          rev = "5f88e5a0fe7dcece0008dae3453edbd99153a042";
          sha256 = "0p941kcqnv4wgcybmhnpzrvxm2y9d2fkd4n186zav7mwfzn736jq";
        };
        dontBuild = true;
        installPhase = ''
          mkdir -p $out
          cp -r ./ $out
        '';
      };
      vim-glaive = pkgs.vimUtils.buildVimPlugin {
        name = "vim-glaive";
        src = pkgs.fetchFromGitHub {
          owner = "google";
          repo = "vim-glaive";
          rev = "c17bd478c1bc358dddf271a13a4a025efb30514d";
          sha256 = "0py6wqqnblr4n1xz1nwlxp0l65qmd76448gz0bf5q9a1sf0mkh5g";
        };
        dontBuild = true;
        installPhase = ''
          mkdir -p $out
          cp -r ./ $out
        '';
      };
    in
    [
      vim-rooter
      base16-vim
      buftabline
      fzf-vim
      fzfWrapper
      # Does not change panes windows when closing buffers
      vim-bufkill
      nerdtree
      ultisnips
      vim-surround
      splitjoin-vim
      vim-multiple-cursors
      vim-easymotion
      tcomment_vim
      delimitMate
      vim-gh-line
      vim-signify
      vim-rhubarb
      vim-fugitive
      # Highlight opened buffers in nerdtree, close buffer with 'w'
      nerdtree-buffer-ops
      vim-diff-enhanced
      committia-vim
      Jenkinsfile-vim-syntax
      vim-terraform
      vim-hclfmt
      nginx-vim
      Vim-Jinja2-Syntax
      html5.vim
      vim-json
      vim-mustache-handlebars
      vim-graphql
      vim-hcl
      vim-go
      rust-vim
      emmet-vim
      yats-vim
      vim-jsx
      yajs-vim
      vim-jsx-typescript
      vim-svelte
      # semshi
      vim-nix
      vim-maktaba
      vim-codefmt
      vim-glaive
      vim-bazel
    ];
  };

  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-boot 'on'
          set -g @continuum-boot-options 'iterm'
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '5' # minutes
        '';
      }
      tmuxPlugins.open
      tmuxPlugins.sensible
      tmuxPlugins.resurrect
    ];
  };
}
