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

## Install softwares 

Run and follow the prompts:
	
	./bootstrap.sh
	./setup.py -t all

Use the following command if you just want vim:

    ./setup.py -t vim

Or restore the original files

    ./setup.py -t restore 

## Others

### Requirements

This suit configurations need the following softwares:

* git, vim, tmux 
* mutt, offlineimap, msmtp, python, keyring(python module) 
* irssi, gnupg 

### Setting passord for mail client manually

This step is mainly for offlineimap and mstp, and the parameters are based on
the configuration files(.msmtprc and .offlineimaprc). For instance: 

	$ python -c "import keyring; keyring.set_password('mstp.gmail.com', 'user', 'PASSWORD')"
	# Test that the password is successfully stored:
	$ python -c "import keyring; print keyring.get_password('mstp.gmail.com', 'user')"
	PASSWORD
