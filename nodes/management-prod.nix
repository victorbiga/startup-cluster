{ pkgs, lib, ... }:

let
  k3sConfig = import ../shared/k3s-config.nix {
    inherit pkgs;
    role = "server";
    clusterName = "management";
    labels = [ "env=management" "hardware=pi5" ];
  };
in
{
  imports = [ k3sConfig ];

  config = {

    networking = {
      hostName = "management-prod";
      interfaces.end0.ipv4.addresses = [{
        address = "10.0.0.32";
        prefixLength = 24;
      }];
    };
  };
}