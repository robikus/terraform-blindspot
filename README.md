# Author

Robert Polakovic

# Project

This is my test Terraform project. The goal of this project is to learn Terraform and how it works with AWS.

I want to build a simple infrastructure on AWS free tier using Terraform.

## 1. Upload Dags:

```bash
export AWS_PROFILE={PROFILE}
export S3_CONFIG_BUCKET=nz-co-loyalty-{ENV_NAME}-config
```

To just upload a specific DAG to your specified S3 bucket, run the deploy script for the dag you want to upload

For example, if you wanted to upload `hw_reconciliation`
```bash
./hw_reconciliation/deploy.sh

```

## Terraform

### Author

### Project structure

### Deployment process

I am using Terraform Cloud for better integration with GitHub actions and AWS. 
States and plans are stored in Terraform Cloud.

The workflow is: GitHub actions -> Terraform Cloud -> AWS

How deployemnt works in a nutshell:

- I am using GitHub actions for running my CI/CD workflow
- Terraform Cloud account is used for storing Terraform state files and plans
- AWS credentials are stored in Terraform Cloud account (GitHub uses only Terraform Cloud credentials)
- Terraform deployes AWS resources

### tfvars

Tfvars are great for storing enviroment specific variables but I could not make tfvars work with GitHub Actions.

This seems like a common problem:

https://stackoverflow.com/questions/65329699/switching-terraform-cloud-workspaces-in-github-actions-terraform-cli
https://stackoverflow.com/questions/66680460/is-there-a-way-in-terraform-enterprise-to-read-the-payload-from-vcs/66770918#66770918

I am sure I would brake this problem having more time.


https://wocdgm16tb.execute-api.eu-central-1.amazonaws.com/?env=dev