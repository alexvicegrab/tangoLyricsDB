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
