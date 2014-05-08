#!/bin/bash
set -e

# another software: chrome, sogou pingying, jinshan kuaipan

packages_common=('git' 'vim' 'cscope' 'exuberant-ctags' 'ipython'	\
		'cgvg'							\
		'tmux' 'irssi' 'gnupg' 'openssh-server'			\
		'msmtp' 'offlineimap' 'mutt' 'getmail4'			\ 
		'python-dev' 'cmake' 'build-essential')

python_modules=('pep8' 'keyring' 'python-crontab')

packages_desktop=('retext' 'goldendict' 'mplayer' 'unrar'		\
		  'w3m' 'sysstat''pidgin''nautilus-dropbox')

if command -v lsb_release >/dev/null 2>&1; then
	case "$(lsb_release --id --short)" in
		Ubuntu|Debian)
		packager="apt-get install -y -q"
		packages_debian=('sl' 'cowsay' 'ack-grep')
		;;
	esac

	case "$(lsb_release --id --short | awk '{print $1}')" in
		openSUSE|SUSE)
		packager="zypper install"
		packages_suse=()
		;;
	esac

else
	if [ -f /etc/redhat-release ]; then
		case "$(cat /etc/redhat-release | awk '{print $1}')" in
			CentOS|Red)
			packager="yum install -y -q"
			packages_redhat=()
			;;
		esac
	fi
fi

echo "Installing" ${packages_common[*]}
sudo ${packager}  ${packages_common[*]}

echo "Installing" ${packages_debian[*]}
sudo ${packager} ${packages_debian[*]}

echo "Installing" ${packages_suse[*]}
sudo ${packager} ${packages_suse[*]}

echo "Installing" ${packages_redhat[*]}
sudo ${packager} ${packages_redhat[*]}

sudo easy_install -q pip
echo "Installing python modules" ${python_modules[*]}
sudo pip install -q ${python_modules[*]}

#test -s ~/repos/ || mkdir ~/repos/
#git clone git@github.com:glzhao/config.git ~/repos/
#python ~/repos/config/setup.py -t all
