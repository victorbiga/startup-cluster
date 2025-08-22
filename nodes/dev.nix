{ pkgs, lib, ... }:

let
  k3sConfig = import ../shared/k3s-config.nix {
    inherit pkgs;
    role = "server";
    clusterName = "dev";
    labels = [ "env=dev" "hardware=pi5" ];
  };
in
{
  imports = [ k3sConfig ];

  config = {

    networking = {
      hostName = "dev";
      interfaces.end0.ipv4.addresses = [{
        address = "10.0.0.32";
        prefixLength = 24;
      }];
    };
  };
}