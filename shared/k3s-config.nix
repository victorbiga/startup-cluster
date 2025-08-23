{ pkgs, role, clusterName ? null, labels ? [], clusterInit ? false, ... }:

let
  clusterAddresses = import ./clusters.nix;
  serverAddr = if clusterName != null then clusterAddresses.${clusterName} else "";

  labelFlags = map (label: "--node-label=${label}") labels;

  tokenConfig = if role == "agent" then { tokenFile = "/etc/k3s/token"; } else { };
  tokenFile = if role == "agent" then {
    environment.etc."k3s/token".text = "";
  } else { };

in

{
  services.k3s = {
    enable = true;
    role = role;

    serverAddr = if role == "agent" then serverAddr else "";

    clusterInit = if role == "server" then clusterInit else false;

    extraFlags =
      (if role == "server" then [ "--disable=traefik" ] else []) ++
      labelFlags;

  } // tokenConfig;
} // tokenFile
