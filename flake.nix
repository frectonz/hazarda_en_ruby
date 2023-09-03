{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # https://github.com/cachix/devenv/issues/756
    # https://www.reddit.com/r/Nix/comments/15aa6up/unable_to_use_devenv_up_with_flake_flake_does_not/
    devenv = {
      url = "github:cachix/devenv/v0.6.3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    devenv,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      overlays = [];
      pkgs = import nixpkgs {inherit system overlays;};
    in
      with pkgs; {
        devShells.default = devenv.lib.mkShell {
          inherit inputs pkgs;
          modules = [
            {
              packages = [rubyPackages_3_3.solargraph];
              languages.ruby.enable = true;
              languages.nix.enable = true;
            }
          ];
        };

        formatter = alejandra;
      });
}
