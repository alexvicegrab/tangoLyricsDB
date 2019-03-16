from os import environ

from fabric.api import env, run
from fabric.contrib.files import exists, sed, append
from fabric.context_managers import cd
from fabric.operations import prompt, sudo
from fabtools import require

from blessings import Terminal

t = Terminal()

env.colorize_errors = True
env.shell = "/bin/bash -i -c"


def deploy():
    _setup_byobu()
    _enable_swap()
    _install_packages()
    _download_github("docker")
    _docker_compose()
    #_auto_backup()


def restore_db(filename="TDB_26-05-2018.dump"):
    _restore_database(filename)


def _auto_backup():
    print(t.green("Setup automatic backup with crontab"))
    res = run('crontab -l')
    if "TTdb_dump" not in res:
        run('(crontab -l ; echo "0 0 * * * /var/www/tangoLyricsDB/TTdb_dump.sh") | crontab -')
        print(t.green("Crontab setup"))
    else:
        print(t.yellow("Crontab set-up, no action needed"))


def _docker_compose():
    append("~/.bashrc",
           "export RAILS_ENV=production")
    append("~/.bashrc",
           "export SECRET_KEY_BASE={}".format(environ["SECRET_KEY_BASE"]))
    append("~/.bashrc",
           "export GMAIL_USERNAME={}".format(environ["GMAIL_USERNAME"]))
    append("~/.bashrc",
           "export GMAIL_PASSWORD={}".format(environ["GMAIL_PASSWORD"]))
    with cd("~/tangoLyricsDB"):
        run("docker-compose build")
        run("docker-compose up -d")
        run("docker-compose run app rake db:create")


def _download_github(branch="master"):
    print(t.green("Download TTdb source"))
    if not exists("~/tangoLyricsDB"):
        run('git clone https://github.com/alexvicegrab/tangoLyricsDB.git')
    with cd("~/tangoLyricsDB"):
        run("git checkout {}".format(branch))
        run("git pull")


def _enable_swap():
    print(t.green("Setup SWAP file to prevent Memory Errors"))
    if not exists('/swapfile'):
        sudo('dd if=/dev/zero of=/swapfile bs=4096 count=256k')
        sudo('mkswap /swapfile')
        sudo('chown root:root /swapfile')
        sudo('chmod 0600 /swapfile')
        sudo('swapon /swapfile')
        append('/etc/fstab', '/swapfile       none    swap    sw      0       0', use_sudo=True)
        sudo('echo 10 | sudo tee /proc/sys/vm/swappiness')
        sudo('echo vm.swappiness = 10 | sudo tee -a /etc/sysctl.conf')


def _install_packages():
    print(t.green("Install important Ubuntu packages necessary for rest of installation"))
    try:
        run("docker version")
    except:
        run("sudo apt-get update")
        run("sudo apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common")
        run("curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -")
        run("sudo apt-key fingerprint 0EBFCD88")
        run('sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"')
        run("sudo apt-get update")
        run("sudo apt-get install -y docker-ce docker-ce-cli containerd.io")
    # Enable user to connect to Docker
    run("sudo usermod -a -G docker $USER")
    # Need to install Docker and Docker compose
    try:
        run("docker-compose --version")
    except:
        run('sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose')
        run("sudo chmod +x /usr/local/bin/docker-compose")
    run("sudo apt-get install -y htop")


def _restore_database(backup):
    print(t.green("Restore database for TTdb from backup"))
    backup_file = "./backup/{}.dump".format(backup)
    with cd("~/tangoLyricsDB"):
        sudo("docker exec -i tangolyricsdb_db_1 pg_restore --clean --no-acl --no-owner -U postgres -d tangoLyricsDB_${RAILS_ENV} < " + backup_file)


def _setup_byobu():
    print(t.green("Enable Byobu"))
    run('byobu-enable')
