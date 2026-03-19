{
  description = "Base Linux packages for dotfiles bootstrap";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.buildEnv {
            name = "dotfiles-base-packages";
            paths = with pkgs; [
              bat
              cargo
              cmake
              eza
              fd
              gcc
              gnumake
              htop
              imagemagick
              mise
              neovim
              python3
              ripgrep
              rustc
              uv
              yazi
              zellij
              zoxide
            ];
          };
        });
    };
}
