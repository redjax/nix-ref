let
  x = 1;
  y = 2;
in {
  ## Even though this is in a different scope, the 'inherit'
  #    keyword "borrows" the x, y values from the scope above
  inherit x y;
}
