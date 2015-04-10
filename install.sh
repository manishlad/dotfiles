#!/usr/bin/env bash
#
# Original template based on mitchelh's dotfiles:
# - https://github.com/mitchellh/dotfiles/blob/master/install.sh
#
# This installation is destructive, as it removes exisitng files/directories.
# Use at your own risk.

UNAME=$(uname)

for name in *; do
  if [ ! $name == "README.md" -a ! $name == "install.sh" ]; then
    target="$HOME/.$name"

    if [ -h $target ]; then
      rm $target
    elif [ -d $target ]; then
      rm -rf $target
    fi

    case $UNAME in
        # CYGWIN* | MINGW32*)
        #     cp -R "$PWD/$name" "$target"
        #     echo "Copied $PWD/$name to $target."
        #     ;;
        *)
            ln -s "$PWD/$name" "$target"
            echo "Linked $PWD/$name to $target."
            ;;
    esac
  fi
done

