# Tango Translation Database

This is the project that underlies the Tango Translation Database on www.tangotranslation.com

I developed it to teach myself Ruby on Rails. Read more about its development on my blog http://alexvicegrab.github.io

## Deploying

To deploy a copy of this project, you must follow these steps.

### Instance

Set up a GCP account and a project and create a GCP compute instance by following the `./terraform/instance/README.md`

### Env vars

Make sure you export a set of environmental variables (ideally place these into a `~/envvars/ttdb.sh` file and source them)

    export RAILS_ENV=production
    export SECRET_KEY_BASE=<a secret key base>  # The output of rake secret
    export GMAIL_USERNAME=<your Gmail username>  # I use tangotranslation@gmail.com
    export GMAIL_PASSWORD=<your Gmail password>
    export TTDB_PATH=<Where you downloaded the TTDB git repository> # I typically use ~/tangoLyricsDB

### Python fabric

To install the components on the server we will be using Python Fabric 1.x (2.x has a very different API)

First we will create a python 2.7 environment:

    virtualenv ./venv

    source ./venv/bin/activate

    pip install --upgrade pip

    pip install -r requirements.txt

Then we can run the necessary installation scripts:

    ./venv/bin/fab -H ubuntu@$(terraform output -state=./terraform/instance/terraform.tfstate ip) deploy


## Local setup

Create the relevant docker volumes

    docker volume create --name postgres-vol

Precompile assets (you will need `ruby` and `rake` to do this), in to provide them with the :

    bundle exec rake assets:precompile

Build and run docker-compose thus:

    docker-compose build
    docker-compose up -d

We can create and restore a specific database:
    
    export BACKUP="TDB_2019-03-03"
    docker-compose run app rake db:create
    docker exec -i tangolyricsdb_db_1 pg_restore --clean --no-acl --no-owner -U postgres -d tangoLyricsDB_${RAILS_ENV} < ./backup/${BACKUP}.dump

## Adding a translator

Connect to the VM that is running the app.

    docker exec -it tangolyricsdb_app_1 rails c

This will setup a Rails console prompt.

    @user = User.new(:email => 'email@example.com', :password => 'password', :password_confirmation => 'password')
    @user.save
