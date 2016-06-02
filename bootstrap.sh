#!/bin/bash
set -e

common_packages=('git' 'vim' 'cscope' 'cgvg' 'subversion'		\
		'tmux' 'irssi' 'gnupg' 'openssh-server')

mail_packages=('msmtp' 'offlineimap' 'mutt' 'getmail')
# another software: chrome, sogou pingying
desktop_packages=('retext' 'goldendict' 'mplayer' 'unrar'		\
		  'w3m' 'sysstat' 'pidgin' 'nautilus-dropbox')

python_packages=('python-dev' 'python-pip' 'ipython')
python_modules=('pep8' 'keyring')

rust_packages=('rustc' 'cargo')

ycm_packages=('cmake' 'build-essential' 'python-dev' 'python3-dev')

common_links=('_alias' '_bashrc' '_tmux.conf' '_irssi' '_bin' 		\
		'_git-completion.bash' '_gitconfig' '_git-prompt.sh')

vim_links=('_vimrc' '_ycm_extra_conf.py')
mail_links=('_getmail' '_msmtprc' '_offlineimaprc' '_mutt')

declare -a packager
#platform independence packages
declare -a packages_pip

repo_dir=$(cd `dirname $0`; pwd)

function usage()
{
	echo "bootstrap.sh"
	echo "-d	default action, install base, rust and vim"
	echo "-b	install base tool packages and links. git tmux etc"
	echo "-v	install vim related packages and links. vim and plugins(YCM and others)"
	echo "-D	install desktop related packages"
	echo "-m	install mail related packages, such as mutt, offlinemap etc."
	echo "-p	install python related packages and python modules"
	echo "-r	install rust related packages"
	echo "-s	restore all installed links"
	echo "-h"
}

function update_packagers_by_platform()
{
	if command -v lsb_release >/dev/null 2>&1; then
		case "$(lsb_release --id --short)" in
			Ubuntu|Debian)
			packager="apt-get install -y -q"
			packages_pip=('sl' 'cowsay' 'ack-grep' 'exuberant-ctags')
			;;
		esac

		case "$(lsb_release --id --short | awk '{print $1}')" in
			openSUSE|SUSE)
			packager="zypper install"
			packages_pip=()
			;;
		esac

	else
		if [ -f /etc/redhat-release ]; then
			case "$(cat /etc/redhat-release | awk '{print $1}')" in
				CentOS|Red)
				packager="yum install -y -q"
				packages_pip=()
				;;
			esac
		fi
	fi
}

function setup_links()
{
	links=${@:1}

	for i in ${links[@]}; do
		if [[ -f ~/.${i#_} ]]; then
			echo "mv -f"  ~/.${i#_}{,.restore}
			mv -f ~/.${i#_}{,.restore}
		fi
		echo "link" ${repo_dir}/$i ~/.${i#_}
		ln -s ${repo_dir}/$i ~/.${i#_}
	done
}

function restore_links()
{
	links=${@:1}

	for i in ${links[@]}; do
		if [[ -f ~/.${i#_}.restore ]]; then
			echo "mv -f" ~/.${i#_}{.restore,}
			mv -f ~/.${i#_}{.restore,}
		fi
	done
}

function setup_vim_plugins()
{
	echo "Installing packages for YouCompleteMe" ${ycm_packages[*]}
	sudo ${packager}  ${ycm_packages[*]}

	vim -u $repo_dir/_vimrc +PluginInstall +qall
	#for c-family, golang and rust
	cd ~/.vim/bundle/YouCompleteMe/ && git submodule update --init --recursive \
		&& ./install.sh --clang-completer --gocode-completer --racer-completer
}

function setup_base()
{
	echo "Installing" ${common_packages[*]}
	sudo ${packager}  ${common_packages[*]}

	echo "Installing platform independence packages" ${packages_pip[*]}
	sudo ${packager} ${packages_pip[*]}

	setup_links ${common_links[*]}
}

function setup_desktop()
{
        echo "Installing desktop related packages"
	sudo ${packager}  ${desktop_packages[*]}
}

function setup_rust()
{
	echo "Installing rust related packages"
	sudo ${packager}  ${rust_packages[*]}
}

function setup_python()
{
	echo "Installing python packages" ${python_packages[*]}
	sudo ${packager}  ${python_packages[*]}

	echo "Installing python modules" ${python_modules[*]}
	sudo pip install -q ${python_modules[*]}
}

function setup_vim()
{
	setup_links ${vim_links[*]}
	setup_vim_plugins
}

function setup_mail()
{
	echo "Installing mail related packages"
	sudo ${packager}  ${mail_packages[*]}

	#TODO setup mail servers and password etc.
	setup_links ${mail_links[*]}
}

function restore_all()
{
	echo "restore all old files"
	restore_links ${common_links[*]} ${vim_links[*]} ${mail_links[*]}
}

function main()
{
	update_packagers_by_platform

	while getopts "dbvDmprsh" arg
	do
		case $arg in
		     d)
			setup_base
			setup_rust
			setup_vim
			;;
		     b)
			setup_base
			;;
		     v)
			# must setup base first
			setup_base
			setup_vim
			;;
		     D)
			setup_desktop
			;;
		     m)
			setup_mail
			;;
		     p)
			setup_python
			;;
		     r)
			setup_rust
			;;
		     s)
			restore_all
			;;
		     h)
			usage
			;;
		     ?)
		        echo "unknow argument"
			usage
			exit 1
			;;
		esac
	done
}

main $@
