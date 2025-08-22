{ pkgs, lib, ... }:

let
  k3sConfig = import ../shared/k3s-config.nix {
    inherit pkgs;
    role = "agent";
    clusterName = "dev";
    labels = [ "env=dev" "hardware=pi4" ];
  };
in
{
  imports = [ k3sConfig ];

  config = {

    networking = {
      hostName = "dev-worker-1";
      interfaces.end0.ipv4.addresses = [{
        address = "10.0.0.34";
        prefixLength = 24;
      }];
    };
  };
}