# Kvantum - Styles


{ ... }:

let
  stylesList = builtins.attrNames (builtins.readDir ./styles);
  styles = builtins.listToAttrs (
    builtins.concatLists ( # concat lists: [ [ name = X; value = Y]... ]
      map (d: # map every style folder
        map (f: { # map every X style file as an environment.etc attribute
          name = "Kvantum/${d}/${f}";
          value = {
            source = "${./styles}/${d}/${f}";
            force = true;
          };
        }) (builtins.attrNames (builtins.readDir "${./styles}/${d}"))
      ) stylesList
    )
  );
in
{
  xdg.configFile = styles;
}
