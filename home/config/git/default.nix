# Home - Config - Git


{ ... }:

{
  programs.git = {
    enable = true;
    
    userEmail = "alexander.kobrys@proton.me";
    userName = "gromif";
    
    extraConfig = {
      submodule = {
        recurse = true;
      };
    };
  };
}
