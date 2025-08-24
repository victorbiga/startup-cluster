{
  description = "NixOS Raspberry Pi configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix";
  };

  outputs = { self, nixpkgs, nixos-hardware, raspberry-pi-nix }: {
    # Helper function to generate NixOS configurations for nodes
    mkNode4 = nodeConfig: nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";  # Architecture defined once
      modules = [
        raspberry-pi-nix.nixosModules.raspberry-pi # Add this line
        raspberry-pi-nix.nixosModules.sd-image # Add this line
        nixos-hardware.nixosModules.raspberry-pi-4 # Keep this
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        "${nixpkgs}/nixos/modules/profiles/minimal.nix"
        ./shared/config.nix
        ./shared/rpi4.nix
        nodeConfig
      ];
    };
    mkNode5 = nodeConfig: nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";  # Architecture defined once
      modules = [
        raspberry-pi-nix.nixosModules.raspberry-pi
        raspberry-pi-nix.nixosModules.sd-image
        "${nixpkgs}/nixos/modules/profiles/minimal.nix"
        ./shared/config.nix  # Common configurations for all nodes
        ./shared/rpi5.nix
        nodeConfig  # Specific node configuration
      ];
    };

    nixosConfigurations = {
      # Node configurations using the mkNode helper function
      management-prod = self.mkNode5 ./nodes/management-prod.nix;
      dev = self.mkNode5 ./nodes/dev.nix;
      dev-worker-1 = self.mkNode4 ./nodes/dev-worker-1.nix;
      dev-worker-2 = self.mkNode4 ./nodes/dev-worker-2.nix;
      prod = self.mkNode5 ./nodes/prod.nix;
      prod-worker-1 = self.mkNode4 ./nodes/prod-worker-1.nix;
    };
  };
}
