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

repo_dir=`dirname $0`

function usage()
{
	echo "-d	install with desktop related packages."
	echo "-m	install with mail related packages, such as mutt, offlinemap etc."
	echo "-p	install with python related packages and python modules"
	echo "-r	install with rust related packages(default)"
	echo "-s	restore all installed links"
	echo "-h
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

	for i in ${ipset[@]}; do
		mv ~/.${i#_}{,.restore}
		ln -s ${repo_dir}/$i ~/.${i#_}
	done
}

function restore_links()
{
	links=${@:1}

	for i in ${ipset[@]}; do
		if [[ -f ~/.${i#_}.restore ]]; then
			mv ~/.${i#_}{.restore,}
		fi
	done
}

function setup_vim_plugins()
{
	vim -u $repo_dir/_vimrc +PluginInstall +qall
	#for c-family, golang and rust
	cd ~/.vim/bundle/YouCompleteMe/ && git submodule update --init --recursive \
		&& ./install.sh --clang-completer --gocode-completer --racer-completer
}

function main()
{
	update_packagers_by_platform

	echo "Installing" ${common_packages[*]}
	sudo ${packager}  ${common_packages[*]}

	echo "Installing platform independence packages" ${packages_pip[*]}
	sudo ${packager} ${packages_pip[*]}

	echo "Installing packages for YouCompleteMe" ${ycm_packages[*]}
	sudo ${packager}  ${ycm_packages[*]}

	echo "Installing rust related packages"
	sudo ${packager}  ${rust_packages[*]}

	setup_links $common_links $vim_links

	while getopts "dmprs" arg
	do
		case $arg in
		     d)
		        echo "Installing desktop related packages"
			sudo ${packager}  ${desktop_packages[*]}
			;;
		     m)
			setup $mail_links
			#TODO setup mail servers and password etc.
		        echo "Installing mail related packages"
			sudo ${packager}  ${mail_packages[*]}
			;;
		     p)
			echo "Installing python packages" ${python_packages[*]}
			sudo ${packager}  ${python_packages[*]}

			echo "Installing python modules" ${python_modules[*]}
			sudo pip install -q ${python_modules[*]}
			;;
		     r)
		        echo "Installing rust related packages"
			sudo ${packager}  ${rust_packages[*]}
			;;
		     s)
		        echo "restore all old files"
			restore_links $common_links $vim_links $mail_links
			;;
		     ?)
		        echo "unkonw argument"
			usage()
			exit 1 ;;
		esac
	done

	setup_vim_plugins()
}
