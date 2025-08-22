{ pkgs, lib, ... }:

let
  k3sConfig = import ../shared/k3s-config.nix {
    inherit pkgs;
    role = "agent";
    clusterName = "prod";
    labels = [ "env=prod" "hardware=pi4" ];
  };
in
{
  imports = [ k3sConfig ];

  config = {

    networking = {
      hostName = "prod-worker-1";
      interfaces.end0.ipv4.addresses = [{
        address = "10.0.0.37";
        prefixLength = 24;
      }];
    };
  };
}