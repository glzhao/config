export PATH=$HOME/.bin:$PATH:/sbin:/usr/sbin
export MANPATH=$HOME/.bin/man:$MANPATH
export EDITOR=$(which vim)
export CHEATCOLORS=true

eval "$(fasd --init auto)"

test -s ~/.alias && source ~/.alias || true
