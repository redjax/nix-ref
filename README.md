# Nix Reference

My reference repo as I learn [`nix`](https://nixos.org).

Example `.nix` files are in the [`nix.dev-examples/`](./nix.dev-examples/) directory. These example files were created following the [`nix.dev tutorial site`](https://nix.dev/tutorials/first-steps/).

Each folder has a `README.md` with instructions for running the examples.

## Notes

### Nix repl

- Exit with `:q`
- Show full output by prepending `:p`
    - i.e. `:p { a.b.c = 1; }`
- Evaluate (run) a `.nix` file with:
  - `$ nix-instantiate --eval /path/to/file.nix`
    - Evaluating a `.nix` file with `nix-instantiate --eval` runs the code as if the commands were typed in `nix repl`
- Whitepsace is used to delimit lexical tokens (`let`, `in`, etc). It is insignificant when evaluted
  - Example: these 2 expressions are equal when evaluated, they will both output `3`:
    ```
    let
      x = 1;
      y = 2;
    in x + y
    ```

    AND

    ```
    let x=1;y=2;in x+y
    ```

## Language Basics

### Evaluate with `nix-instantiate --eval`
- Some expressions (`*.nix` files) will be fully evaluated when running with `nix-instantiate --eval`.
  - This results in output like `[ <CODE> <CODE> <CODE> ]` when `[ 1 2 3 ]` is expected.
  - To suppress this behavior, run `nix-instantiate --eval` commands with the `--strict` flag

### `let ... in ...` expressions
- `let expression`s/`let binding`s assign names and values for repeated use
  - Example:
    ```
    let
      a = 1;
    in
    a + a

    ## Evaluates to '2'
    ```

    ```
    let
      a = 1;
      b = a + 1;
    in
    a + b

    ## Evaluates to 3
    ```

### Attribute sets
- [Attribute sets](https://nixos.org/manual/nix/stable/language/values.html#attribute-set) are variables that can be accessed with dot.notation
  - Example:
    ```
    let
      attrset = { x = 1; };
    in
      attrset.x
    ```
    
    ```
    let
      attrset = { a = { b = { c = 1; }; }; };
    in
      attrset.a.b.c
    ```
  - Attribute dot.notation can also be used for assigning attributes
    - Example:
      ```
      { a.b.c = 1; }
      ```
### `with` statements
- Allow access to attributes without repeatedly referencing their attribute set
  - Example:
    ```
    let
      a = {
        x = 1;
        y = 2;
        z = 3;
      }
    in
    with a; [x y z]
    ```
  - The expression `with a; [ x y z ]` is equivalent to `[ a.x a.y a.z ]`

### `inherit` statements
- Assigns the value of a name from an existing scope to the same name in a nested scope.
  - This helps avoid repeating the same value name multiple times
  - Example:
    ```
    let
      x = 1;
      y = 2;
      in
      {
        ## Equivalent to x = x; y = y;
        inherit x y;
      }
    ```
  - You can also inherit from specific attribute sets with (parentheses)
    - Example:
      ```
      let
        a = { x = 1; y = 2; };
      in
      {
        ## Equivalent to x = a.x; y = a.y;
        inherit (a) x y;
      }
      ```
  - The `inherit` keyword also work in `let` expressions
    - This is useful for defining more complex inheritance. The example below is simple and doesn't fully demonstrate the usefulness of this style of inheritance. If/when I get to a more relevant real-world example, I will update this example
    - Example:
      ```
      let
        x = { x = 1; y = 2; }.x;
        y = { y = 1; y = 2; }.y;
      in
        ...
      ```

### String interpolation
- Like Bash, Nix does string interpolation with `${ ... }`
- The value of a Nix expression can be inserted into a string with this syntax
- Example:
  ```
  let
    name = "Nix";
  in
  "hello ${name}"
  ```
- **NOTE**: Only character strings & values that can be represented as a string are allowed
  - Example of invalid string interpolation:
    ```
    let
      x = 1;
    in
    "${x} + ${x} + ${x + x}
    ```

    Produces an error "cannot coerce an integer to a string"

### Filesystem paths
- Nix handles relative & absolute paths similar to a Bash shell
- Absolute paths start with a `/`
- Paths that start with `./` or no `/` are relative to the shell's `$CWD`

### Lookup paths ("angle bracket syntax")
- **NOTE**: Nix's documentation recommends against using lookup paths in production code, as they are "[impurities](https://nix.dev/tutorials/nix-language#impurities)" which are not reproducible.
- [Lookup path Reference](https://nixos.org/manual/nix/unstable/language/constructs/lookup-path)
- Lookup paths depend on the value of [`builtins.nixPath`](https://nixos.org/manual/nix/stable/language/builtin-constants#builtins-nixPath)
- Lookup paths are denoted with `<angle/brackets>`
- Example:
  ```
  ## /nix/var/nix/profiles/pre-user/root/channels/nixpkgs
  <nixpkgs>
  ```

  ```
  ## /nix/var/nix/profiles/pre-user/root/channels/nixpkgs/lib
  <nixpkgs/lib>
  ```

### Multiline/indented strings 
- For long strings that cover multiple lines, use multiline strings, denoted by `''double single quotes''`
- Example:
  ```
  ''
  multi
  line
  string
  ''
  ```

  ```
  ''
  one
    two
      three
  ''
  ```

### Functions
- Functions always take exactly 1 argument.
- Argument & function bodies are separated with a `:` colon
  - On the left is the function argument
  - On the right is the function body
- Functions are the 3rd way to assign names to values (besides [`attribute sets`](#attribute-sets) and [`let expressions`](#let--in--expressions))
  - Unlike attribute sets & let expressions, function values are not known in advance.
  - Like in other programming languages, function variables ("names" in Nix) are placeholders that will be filled by the function's input/operations
- Functions can be declared a number of ways:
  - Single argument
    ```
    x: x + 1
    ```
    - Multiple arguments via nesting
      ```
      x: y: x + y
      ```
  - Attribute set argument
    ```
    { a, b }: a + b
    ``` 
    - With default attributes
      ```
      { a, b ? 0 }: a + b
      ``` 
    - With additional attributes
      ```
      { a, b, ... }: a + b
      ```
  - Named attribute set argument
    ```
    args@{ a, b, ... }: a + b + args.c
    ```

    OR

    ```
    { a, b, ... }@args: a + b + args.c
    ```
- Functions do not have a name; they are "anonymous," or "lambda" functions
  - Example:
    ```
    let
      f = x: x + 1;
    in f
    ```
- Calling a function is similar to Bash, where you simple write the function's name and pass a value
  - Example:
    ```
    let
      f = x: x + 1;
    in f 1
    ```

    ```
    let
      f = x: x.a;
    in
    f { a = 1; }
    ```
- If a function is not declared with a name in a `let` statement, it can be instantiated & called by surrounding the function logic in parentheses
  - Example:
    ```
    (x: x + 1) 1
    ```

## Links

- [Nix Manual](https://nix.dev/manual/nix/2.18/language/)
- [NixOS Homepage](https://nixos.org)
    - [NixOS Download](https://nixos.org/download)
    - [NixOS Installation Instructions](https://nixos.org/download#download-nix)
- [NixOS Package Repository](https://search.nixos.org/packages)
- [NixOS Github Organization](https://github.com/NixOS)
    - [Github: Nix package manager](https://github.com/NixOS/nix)
- [Nix.dev - Developer documentation site](https://nix.dev)
    - [Nix.dev Tutorials Overview](https://nix.dev/tutorials/)
    - [Declarative Shell env](https://nix.dev/tutorials/first-steps/declarative-shell)
    - [Nix language basics](https://nix.dev/tutorials/nix-language)

- [pkgs.mkShell Reference](https://nixos.org/manual/nixpkgs/stable/#sec-pkgs-mkShell)
- [Nixpkgs shell functions/utilities Reference](https://nixos.org/manual/nixpkgs/stable/#ssec-stdenv-functions)
- [`nix-shell` Reference](https://nix.dev/manual/nix/2.18/command-ref/nix-shell)
