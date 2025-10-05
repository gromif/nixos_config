# User - Programs - Git


{ ... }:

{
  programs.git = {
    enable = true;
    
    config = {
      user = {
        email = "alexander.kobrys@proton.me";
        name = "gromif";
      };
      submodule = {
        recurse = true;
      };
    };
  };
}
