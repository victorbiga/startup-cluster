{ pkgs, role, clusterName ? null, labels ? [], clusterInit ? false, ... }:

let
  clusterAddresses = import ./clusters.nix;
  serverAddr = if clusterName != null then clusterAddresses.${clusterName} else "";

  labelFlags = map (label: "--node-label=${label}") labels;

in

{
  services.k3s = {
    enable = true;
    role = role;

    serverAddr = if role == "agent" then serverAddr else "";
    clusterInit = if role == "server" then clusterInit else false;

    extraFlags = (if role == "server" then [ "--disable=traefik" ] else []) ++ labelFlags;
  };
}
