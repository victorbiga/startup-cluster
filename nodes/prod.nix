{ pkgs, lib, ... }:

let
  k3sConfig = import ../shared/k3s-config.nix {
    inherit pkgs;
    role = "server";
    clusterName = "prod";
    labels = [ "env=prod" "hardware=pi5" ];
  };
in
{
  imports = [ k3sConfig ];

  config = {

    networking = {
      hostName = "prod";
      interfaces.end0.ipv4.addresses = [{
        address = "10.0.0.33";
        prefixLength = 24;
      }];
    };
  };
}
