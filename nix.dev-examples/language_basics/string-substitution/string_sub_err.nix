# # This example will fail with an error
#    "cannot coerce an integer to a string"
#  This is expected.
let x = 1;
in "${x} + ${x} + ${x + x}"
