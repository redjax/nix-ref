# Nix Reference

My reference repo as I learn [`nix`](https://nixos.org).

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

- Some expressions (`*.nix` files) will be fully evaluated when running with `nix-instantiate --eval`.
  - This results in output like `[ <CODE> <CODE> <CODE> ]` when `[ 1 2 3 ]` is expected.
  - To suppress this behavior, run `nix-instantiate --eval` commands with the `--strict` flag
- `let ... in ...` expressions (i.e. `let expression` or `let binding`) assign names and values for repeated use
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
- `with` statements
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
