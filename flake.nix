{
  description = "Hunor Geréd — personal site";

  nixConfig.extra-experimental-features = [ "pipe-operators" ];

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";
    htnl = {
      url = "github:molybdenumsoftware/htnl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      htnl,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import "${htnl}/overlay.nix") ];
        };
        site = import ./site.nix { inherit pkgs; };
        updateDocs = pkgs.writeShellApplication {
          name = "update-docs";
          runtimeInputs = [ pkgs.coreutils ];
          text = ''
            install -Dm644 ${site}/index.html docs/index.html
          '';
        };
      in
      {
        packages.default = site;
        packages.site = site;
        apps.update-docs = flake-utils.lib.mkApp { drv = updateDocs; };
      }
    );
}
