#!/usr/bin/env bash
#
# Original template based on mitchelh's dotfiles:
# - https://github.com/mitchellh/dotfiles/blob/master/install.sh
#
# This installation is destructive, as it removes exisitng files/directories.
# Use at your own risk.

UNAME=$(uname)

cd $(dirname $0)
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

# Install vim plugins
VIM_TARGET="$HOME/.vim"
if [ -d "$VIM_TARGET" ]; then
    rm -rf $VIM_TARGET
fi
mkdir -p $VIM_TARGET/autoload $VIM_TARGET/bundle && \
    curl -LSso $VIM_TARGET/autoload/pathogen.vim https://tpo.pe/pathogen.vim
echo "Installed pathogen.vim"

declare -a vim_plugins=(
    "https://github.com/sjl/gundo.vim"                # Undo tree
    "https://github.com/scrooloose/nerdtree"          # NERD tree explorer
    "https://github.com/jistr/vim-nerdtree-tabs"      # NERD tree with tabs
    "https://github.com/xuyuanp/nerdtree-git-plugin"  # NERD tree git plugin
    "https://github.com/fholgado/minibufexpl.vim"     # MinibufExpl
    "https://github.com/bling/vim-airline"            # Status/tabline
    "https://github.com/tpope/vim-fugitive"           # Git wrapper
    "https://github.com/airblade/vim-gitgutter"       # Git gutter
    "https://github.com/kien/ctrlp.vim"               # Fuzzy file/buffer/tag finder
    "https://github.com/scrooloose/syntastic"         # Syntax checking
    "https://github.com/tpope/vim-surround"           # Manage quoting/parentheses
    "https://github.com/valloric/youcompleteme"       # Code completion
    "https://github.com/ekalinin/dockerfile.vim"      # Dockerfile syntax
    "https://github.com/pangloss/vim-javascript"      # Javascript
    "https://github.com/elzr/vim-json"                # JSON
    "https://github.com/plasticboy/vim-markdown"      # Markdown
    "https://github.com/klen/python-mode"             # Python-mode
    "https://github.com/mg979/vim-visual-multi"       # Sublime style selection
    "https://github.com/rust-lang/rust.vim.git"       # Rust Syntax
    "https://github.com/majutsushi/tagbar"            # Display tags in window
)

cd $VIM_TARGET/bundle
for i in ${vim_plugins[@]}; do
    git clone --recursive $i
    echo "Downloaded vim plugin $i"
done

