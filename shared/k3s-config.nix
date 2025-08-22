{ pkgs, role, clusterName ? null, labels ? [], ... }:

let
  clusterAddresses = import ../clusters.nix;
  serverAddr = if clusterName != null then clusterAddresses.${clusterName} else "";

  labelFlags = map (label: "--node-label=${label}") labels;

in

{
  services.k3s = {
    role = role;

    serverAddr = if role == "agent" then serverAddr else "";

    extraFlags = (if role == "server" then [ "--disable=traefik" ] else []) ++ labelFlags;
  };
}
