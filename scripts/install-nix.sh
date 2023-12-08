#!/bin/bash

function install_nix() {
    sh <(curl -L https://nixos.org/nix/install) --daemon

    return $?
}

function install_nixfmt() {
    nix-env -f https://github.com/serokell/nixfmt/archive/master.tar.gz -i

    return $?
}

function main() {
    install_nix

    echo ""
    echo "Install nixfmt (for auto-formatting in VSCode)?"
    read -p "> (Y)es/(N)o: " CHOICE

    case $CHOICE in
    [Yy] | [Yy][Ee][Ss])
        echo ""
        echo "Installing nixfmt"
        install_nixfmt
        ;;
    [Nn] | [Nn][Oo])
        echo ""
        echo "Skipping installation of nixfmt"
        install_nixfmt
        ;;
    *)
        echo ""
        echo "Invalid choice: $CHOICE. Skipping nixfmt install."
        echo "If you wish to install manually, run:"
        echo "   $ nix-env -f https://github.com/serokell/nixfmt/archive/master.tar.gz -i"
        ;;
    esac
}

main

EXIT_CODE=$?
case $EXIT_CODE in
0)
    echo ""
    echo "Success installing nix. Please reload your shell with:"
    echo "    '$ exec $SHELL'"
    exit $EXIT_CODE
    ;;
1)
    echo ""
    echo "Error installing nix."
    exit $EXIT_CODE
    ;;
esac
