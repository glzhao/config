#!/bin/bash
set -e

common_packages=('git' 'vim' 'cscope' 'ctags' 'cgvg' 'tmux' 'zsh')
python_packages=('python-dev' 'python-pip' 'ipython')
python_modules=('cheat' 'cppman' 'pep8' 'keyring')

common_links=('_alias' '_sh.common' '_tmux.conf' '_cheat'  '_bin' '_gitconfig' '_git-prompt.sh')
bash_links=('_bashrc' '_git-completion.bash')
zsh_links=('_zshrc' '_oh-my-zsh' '_git-completion.zsh')

declare -a packager
declare -a packages_pip

repo_dir=$(cd `dirname $0`; pwd)

function usage()
{
	echo "bootstrap.sh"
	echo "-a	install all common packages and set all links"
	echo "-c	install common tool packages"
	echo "-p	install python related packages and python modules"
	echo "-z	install oh-my-szh related packages and change default shell"
	echo "-b	install bash links"
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

function install_common_packages()
{
	echo "Installing" ${common_packages[*]}
	sudo ${packager}  ${common_packages[*]}

	echo "Installing platform independence packages" ${packages_pip[*]}
	sudo ${packager} ${packages_pip[*]}

	setup_links ${common_links[*]}
}

function setup_python()
{
	echo "Installing python packages" ${python_packages[*]}
	sudo ${packager}  ${python_packages[*]}

	echo "Installing python modules" ${python_modules[*]}
	sudo pip install -q ${python_modules[*]}
}

function setup_zsh()
{
	echo "Link oh-my-zsh configs and change default shell"
	setup_links ${zsh_links[*]}
	sudo chsh -s $(grep /zsh$ /etc/shells | tail -1)
}

function restore_all()
{
	echo "Restore all old files"
	restore_links ${common_links[*]}
}

	echo "-a	install all common packages and set all links"
	echo "-b	install bash links"
	echo "-c	install common tool packages"
	echo "-p	install python related packages and python modules"
	echo "-z	install oh-my-szh related packages and change default shell"

function main()
{
	update_packagers_by_platform

	while getopts "dbvDmprzsh" arg
	do
		case $arg in
		     a)
			setup_common
			setup_zsh
			;;
		     b)
			setup_base
			;;
		     c)
			setup_base
			;;
		     p)
			setup_python
			;;
		     z)
			setup_zsh
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
