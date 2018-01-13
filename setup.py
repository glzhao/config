#!/usr/bin/python

# setup personal working environment
import os, errno
import sys
import argparse

Packages = ['all', 'common', 'git', 'tmux', 'zsh', 'bash', 'cheat', 'cppman']

Links = {
        'common'    : ['_alias', '_common.sh', '_bin'],
        'git'       : ['_gitconfig', '_git-prompt.sh'],
        'tmux'      : ['_tmux.conf'],
        'zsh'       : ['_zshrc', '_oh-my-zsh'],
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

Pkgs = []
install_with_package = False
link_force = False

def get_package_manager():
    if sys.platform.startswith('darwin'):
        return 'brew install'
    elif sys.platform.startswith('cygwin') or sys.platform.startswith('win'):
        return None
    elif sys.platform.startswith('linux'):
        return 'sudo yum install -y'

def symlink_force(target, link_name):
    try:
        os.symlink(target, link_name)
    except OSError, e:
        if e.errno == errno.EEXIST:
            os.unlink(link_name)
            os.symlink(target, link_name)
        else:
            raise e

def link(files):
    for f in files:
        if f[0] != '_':
            continue

        # This script and the config files are in the same directory
        src = os.path.join(os.path.dirname(os.path.abspath(__file__)), f)
        dst = os.path.join(os.path.expanduser("~"), '.' + f[1:])
        if os.path.exists(dst):
            dst_bak = dst + '.df.bak'

            #if os.path.exists(dst_bak):
            #    print "unlink %s\n" %(dst_bak)
            #    if os.path.isdir(dst_bak):
            #        os.remove(dst_bak)
            #    else:
            #        os.unlink(dst_bak)

            print "rename %s to %s\n" %(dst, dst_bak)
            os.rename(dst, dst_bak)

        print "link %s to %s\n" %(src, dst)
        if link_force:
            symlink_force(src, dst)
        else:
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

    if not install_with_package:
        return

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
    parser.add_argument('--withPackage', help='install packages or not', action="store_true")
    parser.add_argument('--force', help='link config force or not', action="store_true")

    if parser.parse_args().withPackage:
         install_with_package = True

    if parser.parse_args().force:
        link_force = True

    if ['all'] in parser.parse_args().package:
        Pkgs = Packages[1:];
    else:
        for i in parser.parse_args().package:
            Pkgs += i;

    print Pkgs
    stored_dir = os.getcwd()
    for pkg in Pkgs:
        if 'restore' in parser.parse_args().action:
            uninstall_package(pkg)
            print("restore package %s successfully" % pkg)
        else:
            install_package(pkg)
            print("install package %s successfully" % pkg)

    os.chdir(stored_dir)
