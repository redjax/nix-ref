let
  f = x: x.a;
  ## Declare a variable v, which will be passed as an
  #  arg when function f is called
  v = { a = 1; };
in f v
