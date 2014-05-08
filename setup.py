#!/usr/bin/python

# setup personal working environment
import os
import sys
import subprocess
import crontab

vim_files = ["_vimrc", "_ycm_extra_conf.py"]

update_submodules = "git submodule update --init --recursive"
pull_submodules = "git submodule foreach --recursive git pull origin master"

recive_cmd = 'source ~/.Xdbus; ~/.bin/mail-recive.sh'
recive_cmt = 'Mail recive job'
send_cmd = '~/.bin/msmtp-runqueue.sh'
send_cmt = 'Mail send job'


def print_usage():
    print >>sys.stderr, "Usage: setup.py \n[-h, --help <show usage>]\n" \
    "[-t, --target <install which, 'vim' 'all' and 'restore' supported now>]\n"


def parse_opts():
    import getopt
    try:
        opts, args = getopt.getopt(sys.argv[1:], "ht:",  ["target"])
        for o, a in opts:
            if o in ("-t", "--target"):
                target = a.strip()
            if o in ("-h", "--help"):
                print_usage()
                sys.exit(2)
    except:
        print_usage()
        sys.exit(2)

    if target != "all" and target != "vim" and target != "restore":
        print >>sys.stdout, "Doesn't support others except vim, all and restore\n"
        sys.exit(2)
    return target

def local_check_output(*popenargs, **kwargs):
    r"""Run command with arguments and return its output as a byte string.

    If the exit code was non-zero it raises a CalledProcessError.  The
    CalledProcessError object will have the return code in the returncode
    attribute and output in the output attribute.

    The arguments are the same as for the Popen constructor.  Example:

    >>> check_output(["ls", "-l", "/dev/null"])
    'crw-rw-rw- 1 root root 1, 3 Oct 18  2007 /dev/null\n'

    The stdout argument is not allowed as it is used internally.
    To capture standard error in the result, use stderr=STDOUT.

    >>> check_output(["/bin/sh", "-c",
    ...               "ls -l non_existent_file ; exit 0"],
    ...              stderr=STDOUT)
    'ls: non_existent_file: No such file or directory\n'
    """
    if 'stdout' in kwargs:
        raise ValueError('stdout argument not allowed, it will be overridden.')
    process = subprocess.Popen(stdout=subprocess.PIPE, *popenargs, **kwargs)
    output, unused_err = process.communicate()
    retcode = process.poll()
    if retcode:
        cmd = kwargs.get("args")
        if cmd is None:
            cmd = popenargs[0]
        raise subprocess.CalledProcessError(retcode, cmd, output=output)
    return output


def setup_YCM():
# TODO check vim version and features
#    if version of vim is lower than 7.3.584:
#        break
#    if !vim has (python):
#        break

    old_path = os.getcwd()
    dst = os.path.join(os.path.expanduser("~"), '.vim/bundle/YouCompleteMe/')
    print dst
    os.chdir(dst)
    os.system(update_submodules)
    os.system("./install.sh --clang-completer")
    os.chdir(old_path)

def setup_vim_plugins():
    vimrc = os.path.join(os.path.dirname(os.path.abspath(__file__)), "_vimrc")
    os.system("vim -u %s +PluginInstall +qall" % (vimrc))
    setup_YCM()


def setup_mail_passwd():
    import getpass
    import keyring
    r = ""

    r == raw_input("Setup passwrd for mail client ? [y]/n:\n")
    while (r != "n"):
        server = raw_input("Server: ")
        user = raw_input("User: ")
        pwd = getpass.getpass("Passwrd: ")
        keyring.set_password(server, user, pwd)
        r = raw_input("More servers ? [y]/n:")

def setup_mail_crontab():
    cron = crontab.CronTab(user=True)

    jobs = list(cron.find_command(send_cmd))
    if len(jobs) is 0:
        print 'Setting up mail send job'
        send_job = cron.new(send_cmd, send_cmt)
        send_job.minute.every(3)
        cron.write()
    jobs = list(cron.find_command(recive_cmd))
    if len(jobs) is 0:
        print 'Setting up mail recive job'
        recive_job = cron.new(recive_cmd, recive_cmt)
        recive_job.minute.every(3)
        cron.write()


def clear_mail_crontab():
    cron = crontab.CronTab(user=True)
    print 'Removing mail recive job'
    cron.remove_all(command = recive_cmd)
    cron.remove_all(command = send_cmd)
    cron.write()


def setup_mail():
    xdbus = os.path.join(os.path.expanduser("~"), '.Xdbus')
    if not os.path.exists(xdbus):
        old_path = os.getcwd()
        os.chdir(os.path.dirname(os.path.abspath(__file__)))
        os.system("./_bin/export_x_info.sh")
        os.chdir(old_path)

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

if __name__ == "__main__":
    target = parse_opts()

    # To compatbile with older python (<2.7)
    if not 'check_output' in dir(subprocess):
        subprocess.check_output = local_check_output

    IGNORE = open("/dev/null", "w")
    stored_dir = os.getcwd()

    print target
    if target == "vim":
        link(vim_files)
        setup_vim_plugins()
    elif target == "all":
        path = os.path.dirname(os.path.abspath(__file__))
        all_files = os.listdir(path)
        for f in all_files:
            if f[0] != '_':
                all_files.remove(f)
        link(all_files)
        setup_vim_plugins()
        setup_mail_passwd()
        setup_mail()
        setup_mail_crontab()
    else:
        path = os.path.dirname(os.path.abspath(__file__))
        all_files = os.listdir(path)
        for f in all_files:
            if f[0] != '_':
                all_files.remove(f)
        restore(all_files)
        clear_mail_crontab()

    os.chdir(stored_dir)
    IGNORE.close()
