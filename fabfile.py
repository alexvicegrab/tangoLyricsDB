from fabric.api import env, run
from fabric.contrib.files import exists, sed, append
from fabric.context_managers import cd
from fabric.operations import prompt, sudo
from fabtools import require

from blessings import Terminal

t = Terminal()


def deploy():
    _setup_byobu()
    _enable_swap()
    _install_packages()
    _install_rbenv()
    _install_postgres('9.5')
    _install_webserver()
    _download_github()
    _install_bundle()
    _setup_database('9.5')
    _configure_webserver()
    _start_webserver()
    _auto_backup()


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


def _configure_webserver():
    print(t.green("Configure the web server"))
    sed('/opt/nginx/conf/nginx.conf',
        'root   html;',
        'root   /var/www/tangoLyricsDB/public;   # root   html;',
        use_sudo=True)
    sed('/opt/nginx/conf/nginx.conf',
        'index  index.html index.htm;',
        'passenger_enabled on;   # index  index.html index.htm;',
        use_sudo=True)
    # Update Nginx init script with key variables
    if not exists('/etc/init.d/nginx'):
        with cd('/var/www/tangoLyricsDB'):
            sudo('cp init.d-nginx /etc/init.d/nginx')
            sudo('chmod 755 /etc/init.d/nginx')
            sudo('chown root:root /etc/init.d/nginx')
            sudo('update-rc.d nginx defaults')
            sudo('update-rc.d nginx enable')
    secret_key = prompt('What is the SECRET_KEY_BASE? for TTdb?')
    append('/etc/init.d/nginx',
           'export SECRET_KEY_BASE={}'.format(secret_key),
           use_sudo=True)
    append('/etc/init.d/nginx',
           'export GMAIL_DOMAIN=mail.google.com',
           use_sudo=True)
    append('/etc/init.d/nginx',
           'export GMAIL_USERNAME=tangotranslation@gmail.com',
           use_sudo=True)
    gmail_psswd = prompt('What is the GMAIL_PASSWORD for the TTdb Mailer?')
    append('/etc/init.d/nginx',
           'export GMAIL_PASSWORD={}'.format(gmail_psswd),
           use_sudo=True)
    psql_psswd = prompt('What is the TANGOLYRICSDB_DATABASE_PASSWORD?')
    append('/etc/init.d/nginx',
           'export TANGOLYRICSDB_DATABASE_PASSWORD={}'.format(psql_psswd),
           use_sudo=True)


def _download_github():
    print(t.green("Download TTdb source"))
    if not exists('/var/www'):
        sudo('mkdir -p /var/www')
    sudo('chown ' + env.user + ' /var/www')
    if not exists('/var/www/tangoLyricsDB'):
        run('git clone https://github.com/alexvicegrab/tangoLyricsDB.git /var/www/tangoLyricsDB')


def _enable_swap():
    print(t.green("Setup SWAP file to prevent Memory Errors during compilation of Web Server"))
    if not exists('/swapfile'):
        sudo('dd if=/dev/zero of=/swapfile bs=4096 count=256k')
        sudo('mkswap /swapfile')
        sudo('chown root:root /swapfile')
        sudo('chmod 0600 /swapfile')
        sudo('swapon /swapfile')
        append('/etc/fstab', '/swapfile       none    swap    sw      0       0', use_sudo=True)
        sudo('echo 10 | sudo tee /proc/sys/vm/swappiness')
        sudo('echo vm.swappiness = 10 | sudo tee -a /etc/sysctl.conf')


def _install_bundle():
    print(t.green("Install Ruby gem bundle for TTdb"))
    with cd('/var/www/tangoLyricsDB'):
        run('gem install bundler')
        run('bundle update')
        run('bundle install')


def _install_packages():
    print(t.green("Install important Ubuntu packages necessary for rest of installation"))
    # Need Node & Yarn for Ruby (https://gorails.com/setup/ubuntu/17.10)
    run('curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -')
    run('curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -')
    run('echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list')
    sudo('apt update')
    sudo('apt install htop -y')
    sudo('apt install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nodejs yarn -y')


def _install_rbenv():
    try:
        run('ruby -v')
    except:
        run('git clone https://github.com/rbenv/rbenv.git ~/.rbenv')
        run('echo \'export PATH="$HOME/.rbenv/bin:$PATH"\' >> ~/.bash_profile')
        run('echo \'eval "$(rbenv init -)"\' >> ~/.bash_profile')
        run('git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build')
        run('echo \'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"\' >> ~/.bash_profile')
        run('rbenv install 2.5.1')
        run('rbenv global 2.5.1')


def _install_webserver():
    print(t.green("Install Webserver [passenger & nginx]"))
    try:
        run('passenger -v')
    except:
        run('gem install passenger')
    if not exists('/opt/nginx'):
        sudo('`which passenger-install-nginx-module` --auto --prefix=/opt/nginx --auto-download --extra-configure-flags=none --languages ruby')


def _install_postgres(version):
    print(t.green("Install postgres dependencies and tangoLyricsDB user"))
    sudo('apt install -y postgresql-server-dev-' + version)
    # TODO: Currently we ask for the same password twice, how can we DRY?
    psql_psswd = prompt('Provide password for tangoLyricsDB postgreSQL user')
    try:
        require.postgres.user('tangoLyricsDB', psql_psswd, createdb=True)
    except:
        print(t.yellow('tangoLyricsDB user probably exists'))


def _restore_database(filename):
    print(t.green("Restore database for TTdb from backup"))
    with cd('/var/www/tangoLyricsDB'):
        sudo('pg_restore --verbose --clean --no-acl --no-owner -h localhost -U tangoLyricsDB -d tangoLyricsDB_production backup/{fn}'.format(fn=filename), user='postgres')


def _setup_byobu():
    print(t.green("Enable Byobu"))
    run('byobu-enable')


def _setup_database(version):
    print(t.green("Setup TTdb database"))
    sed('/etc/postgresql/' + version + '/main/pg_hba.conf',
        'local   all             all                                     peer',
        'local   all             all                                     trust',
        use_sudo=True)
    sed('/etc/postgresql/' + version + '/main/pg_hba.conf',
        'local   all             postgres                                peer',
        'local   all             postgres                                trust',
        use_sudo=True)
    sudo('service postgresql restart')
    with cd('/var/www/tangoLyricsDB'):
        run('RAILS_ENV=production bundle exec rake db:create db:schema:load')


def _start_webserver():
    sudo('service nginx start')
