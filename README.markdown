## Introducation

This is my personal configuration files backup. The idea and many
configuration files are from sontek/dotfiles in github.com. Thanks
very much.

Any file which matches the shell glob `_*` will be linked into `$HOME`
as a symlink with the first `_`  replaced with a `.`
For example:

    _bashrc

becomes

    ${HOME}/.bashrc

So, just add a `_*` style file, if you want new configuration files.

## Install softwares and link config files

### Install softwares

Run and follow the prompts:

    sudo yum/apt-get install -y vim cscope ctags cgvg ipython git tmux zsh
    pip install cheat cppman

### setup links

Run and follow the prompts:

    ./setup.py -p all -a install --force

Use the following command if you just want tmux:

    ./setup.py -p tmux -a install --force

Or restore the original files

    ./setup.py -p tmux -a restore --force

## Others

### Requirements

This suit configurations need the following softwares:

* git, vim, tmux, python
Packages = ['all', 'common', 'git', 'tmux', 'zsh', 'bash', 'cheat', 'cppman']
