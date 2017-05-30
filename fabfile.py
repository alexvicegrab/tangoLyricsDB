from fabric.api import env, run
from fabric.contrib.files import exists, sed
from fabric.context_managers import cd, hide
from fabric.operations import prompt
from fabtools import require
from fabtools import postgres


def deploy():
    _setup_byobu()
    _enable_swap()
    _install_packages()
    _install_postgres()
    _install_webserver()
    _configure_webserver()
    _download_github()
    _install_bundle()
    _setup_database()
    _start_webserver()


def restore_db():
    _restore_database()


def _configure_webserver():
    sed('/opt/nginx/nginx.conf', 'root   html;', 'root   /var/www/tangoLyricsDB/public;   # root   html;', use_sudo=True)
    sed('/opt/nginx/nginx.conf', 'index  index.html index.htm;', 'passenger_enabled on;   # index  index.html index.htm;', use_sudo=True)
    # Update Nginx init script with key variables
    secret_key = raw_input('What is the SECRET_KEY_BASE? for TTdb?')
    append('/etc/init.d/nginx', 'export SECRET_KEY_BASE={}'.format(secret_key), use_sudo=True)
    append('/etc/init.d/nginx', 'export GMAIL_DOMAIN=mail.google.com', use_sudo=True)
    append('/etc/init.d/nginx', 'export GMAIL_USERNAME=tangotranslation@gmail.com', use_sudo=True)
    gmail_passwd = raw_input('What is the GMAIL_PASSWORD for the TTdb Mailer?')
    append('/etc/init.d/nginx', 'export GMAIL_PASSWORD={}'.format(gmail_passwd), use_sudo=True)


def _download_github():
    if not exists('/var/www/tangoLyricsDB'):
        run('git clone https://github.com/alexvicegrab/tangoLyricsDB.git /var/www/tangoLyricsDB')


def _enable_swap():
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
    with cd('/var/www/tangoLyricsDB'):
        run('gem install bundler')
        run('bundle update')
        run('bundle install')


def _install_packages():
    run('sudo apt update')
    run('sudo apt install ruby ruby-dev build-essential libpq-dev libcurl4-openssl-dev -y')


def _install_webserver():
    run('gem install passenger')
    run('passenger-install-nginx-module --auto --prefix=/opt/nginx --auto-download --extra-configure-flags=none --languages ruby')


def _install_postgres():
    #run('sudo apt-get update')
    #run('sudo apt-get install postgresql postgresql-contrib')
    require.postgres.server()
    try:
        require.postgres.user('tangoLyricsDB', 'TheTangoTranslationDataBase', createdb=True)
    except:
        print('tangoLyricsDB user probably exists')


def _restore_database():
    with cd('/var/www/tangoLyricsDB'):
        run('pg_restore --verbose --clean --no-acl --no-owner -h localhost -U tangoLyricsDB -d tangoLyricsDB_development ~/backup/*.dump')


def _setup_byobu():
    run('byobu-enable')


def _setup_database():
    with cd('/var/www/tangoLyricsDB'):
        run('RAILS_ENV=production bundle exec rake db:create db:schema:load')


def _start_webserver():
    run('sudo service nginx start')

