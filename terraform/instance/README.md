# Terraform

## Creating

These files have been created according to [this guide](https://cloud.google.com/community/tutorials/getting-started-on-gcp-with-terraform).

You will need a GCP account and a project.

Create a credentials JSON and name it `GCP_TangoTranslation_creds.json`, placing it a level above the repository.

You may wish to change some of the parameters in the `./terraform/instance/variables.tf` according to your wishes.

Initialise terraform:

    terraform init

Plan and create the resources

    terraform plan
    
    terraform apply
