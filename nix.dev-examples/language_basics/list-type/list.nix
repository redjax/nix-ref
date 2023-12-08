let
  ## Attributes can be assigned in any order
  b = a + 1;
  c = a + b;
  a = 1;
  ## List evaluated as [1 2 3] (a b c)
in [ a b c ]
