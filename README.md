# Tango Translation Database

This is the project that underlies the Tango Translation Database on www.tangotranslation.com

I developed it to teach myself Ruby on Rails. Read more about its development on my blog http://alexvicegrab.github.io

## Deploying

To deploy a copy of this project, you must follow these steps.

### Instance

Set up a GCP account and a project and create a GCP compute instance by following the `./terraform/instance/README.md`

### Python fabric

To install the components on the server we will be using Python Fabric 1.x (2.x has a very different API)

First we will create a python 2.7 environment:

    virtualenv ./venv

    source ./venv/bin/activate

    pip install --upgrade pip

    pip install -r requirements.txt

Then we can run the necessary installation scripts:

    ./venv/bin/fab -H ubuntu@$(terraform output -state=./terraform/instance/terraform.tfstate ip) deploy

# Docker Compose

Build and run docker-compose thus:

    export RAILS_ENV="production"
    export SECRET_KEY_BASE=$(rake secret)
    docker-compose build
    docker-compose up

Precompile assets:

    docker-compose run web bundle exec rake assets:precompile

We can create and restore a specific database:
    
    export BACKUP="TDB_2019-03-03"
    docker-compose run web rake db:create
    docker exec -i tangolyricsdb_db_1 pg_restore --clean --no-acl --no-owner -U postgres -d tangoLyricsDB_${RAILS_ENV} < ./backup/${BACKUP}.dump 
