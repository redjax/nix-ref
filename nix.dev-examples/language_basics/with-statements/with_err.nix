# # Running this with nix-instantiate --eval will produce an error
#  regarding an undefined variable 'x'. This is expected.
let
  a = {
    x = 1;
    y = 2;
    z = 3;
  };
in {
  b = with a; [ x y z ];
  c = x;
}
