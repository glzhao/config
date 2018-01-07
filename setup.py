#!/usr/bin/python

# setup personal working environment
import os
import sys
import argparse

Packages = ['all', 'common', 'git', 'tmux', 'zsh', 'bash', 'cheat', 'cppman']

Links = {
        'common'    : ['_alias', '_sh.common', '_bin'],
        'git'       : ['_gitconfig', '_git-prompt.sh'],
        'tmux'      : ['_tmux.conf'],
        'zsh'       : ['_zshrc', '_oh-my-zsh', '_git-completion.zsh'],
        'bash'      : ['_bashrc', '_git-completion.bash'],
        'cheat'     : ['_cheat']
        }

Binarys = {
        'common'    : ['vim', 'cscope', 'ctags', 'cgvg'],
        'ipython'   : ['ipython'],
        'git'       : ['git'],
        'tmux'      : ['tmux'],
        'zsh'       : ['zsh']
        }

Python_modules = {
        'cheat'     : ['cheat'],
        'cppman'    : ['cppman']
        }

def get_package_manager():
    if sys.platform.startswith('darwin'):
        return 'brew install'
    elif sys.platform.startswith('cygwin') or sys.platform.startswith('win'):
        return None
    elif sys.platform.startswith('linux'):
        return 'sudo yum install -y'

def link(files):
    for f in files:
        if f[0] != '_':
            continue

        # This script and the config files are in the same directory
        src = os.path.join(os.path.dirname(os.path.abspath(__file__)), f)
        dst = os.path.join(os.path.expanduser("~"), '.' + f[1:])
        if os.path.exists(dst):
            print "rename %s to %s\n" %(dst, dst + '.df.bak')
            os.rename(dst, dst + '.df.bak')
        print "link %s to %s\n" %(src, dst)
        os.symlink(src, dst)

def restore(files):
    for f in files:
        if f[0] != '_':
            continue
        dst = os.path.join(os.path.expanduser("~"), '.' + f[1:])
        print "unlink %s\n" %(dst)
        os.unlink(dst)
        print "rename %s to %s\n" % (dst + '.df.bak', dst)
        if os.path.exists(dst + '.df.bak'):
            os.rename(dst + '.df.bak', dst)

def install_package(pkg):
    if pkg in Links:
        link(Links[pkg])

    pkg_manager = get_package_manager()
    if Binarys.has_key(pkg) and pkg_manager is not None:
        for binary in Binarys[pkg]:
            cmd = pkg_manager + ' ' + binary
            ret = os.system(cmd)
            if ret is 0:
                print("install %s successfully" % binary)
            else:
                print("install %s failed" % binary)

    if Python_modules.has_key(pkg):
        for module in Python_modules[pkg]:
            cmd = 'pip install ' + module
            ret = os.system(cmd)
            if ret is 0:
                print("install %s successfully" % module)
            else:
                print("install %s failed" % module)

def uninstall_package(pkg):
    if pkg in Links:
        restore(Links[pkg])

if __name__ == "__main__":
    parser=argparse.ArgumentParser(description='''Instal packages and links''')
    parser.add_argument('-p', '--package', action='append', nargs=1, choices=Packages, required=True,
            help='module will be in action, set all first time', metavar=Packages)
    parser.add_argument('-a', '--action', nargs=1, choices=['install', 'restore'],
            help='action type, install or restore', default='install')

    pkgs = []
    if ['all'] in parser.parse_args().package:
        pkgs = Packages[1:];
    else:
        for i in parser.parse_args().package:
            pkgs += i;

    print pkgs
    stored_dir = os.getcwd()
    for pkg in pkgs:
        if 'restore' in parser.parse_args().action:
            uninstall_package(pkg)
            #print("restore package %s successfully" % pkg)
        else:
            install_package(pkg)
            #print("install package %s successfully" % pkg)

    os.chdir(stored_dir)
