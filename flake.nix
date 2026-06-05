{
  description = "Hunor Geréd — personal site";

  nixConfig.extra-experimental-features = [ "pipe-operators" ];

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";
    htnl = {
      url = "github:molybdenumsoftware/htnl";
      flake = false;
    };
  };

  outputs =
    { nixpkgs, htnl, ... }:
    let
      systems = [
        "x86_64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;

      siteFor =
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ (import "${htnl}/overlay.nix") ];
          };
        in
        pkgs.callPackage ./site.nix { };
    in
    {
      packages = forAllSystems (
        system:
        let
          site = siteFor system;
        in
        {
          default = site;
          inherit site;
        }
      );
    };
}
