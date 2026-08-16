{pkgs, ...}: let
  # Not packaged in nixpkgs; built from the npm package via buildNpmPackage.
  # --ignore-scripts avoids tree-sitter-cli's postinstall download in the sandbox
  # (the server uses web-tree-sitter wasm, so native tree-sitter isn't needed).
  cucumber-language-server = pkgs.buildNpmPackage {
    pname = "cucumber-language-server";
    version = "1.7.0";
    src = pkgs.fetchFromGitHub {
      owner = "cucumber";
      repo = "language-server";
      rev = "v1.7.0";
      hash = "sha256-GGPajuy1pOidi7Ux+i7CfLjsRT7vsLQRj1IzTXBWPQY=";
    };
    npmDepsHash = "sha256-sjoj7OLZcvFf0g/6kjhWgt/bUNKbbvYqBszNDYHxf4A=";
    npmRebuildFlags = ["--ignore-scripts"];
  };
in {
  config.runtimePkgs = with pkgs; [
    universal-ctags
    clang-tools
    dts-lsp
    ripgrep
    fd
    tree-sitter
    vscode-langservers-extracted
    yaml-language-server
    taplo
    bash-language-server
    shellcheck
    shfmt
    nodejs
    imagemagick
    actionlint
    cspell
    nixd
    nixfmt
    lua-language-server
    stylua
    templ
    lazygit
    gopls
    gotools
    go-tools
    basedpyright
    terraform-ls
    tflint
    tflint-plugins.tflint-ruleset-aws
    tflint-plugins.tflint-ruleset-google
    typescript
    typescript-language-server
    typescript-go
    vtsls
    eslint
    tailwindcss-language-server
    biome
    roslyn-ls
    netcoredbg
    docker-compose-language-service
    dockerfile-language-server
    hadolint
    alejandra
    statix
    csharpier
    prettierd
    sqlfluff
    cucumber-language-server
  ];
}
