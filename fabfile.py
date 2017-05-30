from fabric.api import run
from fabric.contrib.files import exists, sed, append
from fabric.context_managers import cd
from fabric.operations import prompt
from fabtools import require

from blessings import Terminal

t = Terminal()


def deploy():
    _setup_byobu()
    _enable_swap()
    _install_packages()
    _install_postgres()
    _install_webserver()
    _download_github()
    _install_bundle()
    _setup_database()
    _configure_webserver()
    _start_webserver()


def restore_db():
    _restore_database()


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
    gmail_passwd = prompt('What is the GMAIL_PASSWORD for the TTdb Mailer?')
    append('/etc/init.d/nginx',
           'export GMAIL_PASSWORD={}'.format(gmail_passwd),
           use_sudo=True)


def _download_github():
    print(t.green("Download TTdb source"))
    if not exists('/var/www/tangoLyricsDB'):
        run('git clone https://github.com/alexvicegrab/tangoLyricsDB.git /var/www/tangoLyricsDB')


def _enable_swap():
    print(t.green("Setup SWAP file to prevent Memory Errors during compilation of Web Server"))
    if not exists('/swapfile'):
        run('sudo dd if=/dev/zero of=/swapfile bs=4096 count=256k')
        run('sudo mkswap /swapfile')
        run('sudo chown root:root /swapfile')
        run('sudo chmod 0600 /swapfile')
        run('sudo swapon /swapfile')
        append('/etc/fstab', '/swapfile       none    swap    sw      0       0', use_sudo=True)
        run('echo 10 | sudo tee /proc/sys/vm/swappiness')
        run('echo vm.swappiness = 10 | sudo tee -a /etc/sysctl.conf')


def _install_bundle():
    print(t.green("Install Ruby gem bundle for TTdb"))
    with cd('/var/www/tangoLyricsDB'):
        run('gem install bundler')
        run('bundle update')
        run('bundle install')


def _install_packages():
    print(t.green("Install important Ubuntu packages necessary for rest of installation"))
    run('sudo apt update')
    run('sudo apt install htop ruby ruby-dev build-essential libpq-dev libcurl4-openssl-dev -y')


def _install_webserver():
    print(t.green("Install Webserver [passenger & nginx]"))
    try:
        run('passenger -v')
    except:
        run('gem install passenger')
    if not exists('/opt/nginx'):
        run('passenger-install-nginx-module --auto --prefix=/opt/nginx --auto-download --extra-configure-flags=none --languages ruby')


def _install_postgres():
    print(t.green("Install postgres dependencies and tangoLyricsDB user"))
    #run('sudo apt-get update')
    #run('sudo apt-get install postgresql postgresql-contrib')
    require.postgres.server()
    try:
        require.postgres.user('tangoLyricsDB', 'TheTangoTranslationDataBase', createdb=True)
    except:
        print(t.yellow('tangoLyricsDB user probably exists'))


def _restore_database():
    print(t.green("Restore database for TTdb from backup"))
    with cd('/var/www/tangoLyricsDB'):
        run('pg_restore --verbose --clean --no-acl --no-owner -h localhost -U tangoLyricsDB -d tangoLyricsDB_production backup/*.dump')


def _setup_byobu():
    print(t.green("Enable Byobu"))
    run('byobu-enable')


def _setup_database():
    print(t.green("Setup TTdb database"))
    sed('/etc/postgresql/9.5/main/pg_hba.conf',
        'local   all             all                                     peer',
        'local   all             all                                     trust',
        use_sudo=True)
    with cd('/var/www/tangoLyricsDB'):
        run('RAILS_ENV=production bundle exec rake db:create db:schema:load')


def _start_webserver():
    if not exists('/etc/init.d/nginx'):
        with cd('/var/www/tangoLyricsDB'):
            run('cp init.d-nginx /etc/init.d/nginx')
            run('sudo chmod 755 /etc/init.d/nginx')
            run('sudo chown root:root /etc/init.d/nginx')
            run('sudo update-rc.d nginx defaults')
            run('sudo update-rc.d nginx enable')
    run('sudo service nginx start')
