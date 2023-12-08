## https://nix.dev/tutorials/first-steps/declarative-shell
let
    ## Use version of nixpkgs pinned to release branch (22.11).
    #    Specify config & overlays as empty, so they aren't overwritten by global config
    nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixos-22.11";
    pkgs = import nixpkgs { config = {}; overlays = []; };
in

## .mkShell is a function that creates a shell env. mkShell has attributes
#    like "packages," which define the packages to be made available in the Nix shell
pkgs.mkShell {
    packages = with pkgs; [
        git
        neovim
        nodejs
    ];

    ## Set an environment variable, "GIT_EDITOR", with value of Nix's nvim install
    GIT_EDITOR = "${pkgs.neovim}/bin/nvim";

    ## Commands in "shellHook" will be run *before entering the shell environment*.
    #  This happens after package installation, but before you are dropped into the shell
    shellHook = ''
        git status
    '';
}