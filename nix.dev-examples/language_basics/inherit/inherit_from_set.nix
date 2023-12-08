let
  a = {
    x = 1;
    y = 2;
  };
in {
  ## Equivalent to x = a.x; y = a.y;
  inherit (a) x y;
}
