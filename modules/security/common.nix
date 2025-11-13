# Security - Common


{ ... }:

{  
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [];
  # networking.firewall.allowedUDPPorts = [];
  
  # Lock Kernel Modules
  # security.lockKernelModules = true;
  
  # Restrict Nix pm for users outside of the @wheel group
  nix.settings.allowed-users = [ "@wheel" ];
  
  security = {
    # Prevent replacing the running kernel
    protectKernelImage = true;
    
    # Include memory-safe sudo implementation
    sudo.enable = false;
    sudo-rs = {
      enable = true;
      execWheelOnly = true;
    };
  };
}
