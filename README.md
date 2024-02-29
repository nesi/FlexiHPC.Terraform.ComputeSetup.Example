# FlexiHPC.Terraform.ComputeSetup.Example

This example repo is to demonstrate programatically setting up compute services within the FlexiHPC platform using Ansible and Terraform.

## Prerequisites

The following dependencies must be installed on your local machine:

- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html)
  - Ansible is a suite of software tools that enables infrastructure as code. It can configure systems, deploy software
    and orchestrate advanced workflows to support application deployment, system updates and more.
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
  - Terraform is another infrastructure as code software tool. It can create and manage resources on cloud platforms and
    other services through their application programming interfaces (APIs).
- [python-openstackclient](https://github.com/openstack/python-openstackclient)
  - The python-openstackclient is a Python package that provides a command line interface (CLI) to an OpenStack cloud, such
    as NeSI's Flexi platform.

## Steps

Inside the `terraform.tfvars` file is some user configuration required.

```
user_name   = "FLEXIHPC_USER"
tenant_name = "FLEXIHPC_PROJECT_NAME"
auth_url    = "https://keystone.akl-1.cloud.nesi.org.nz/v3"
region      = "akl-1"

key_pair    = "FLEXIHPC_KEYPAIR_NAME"
key_file    = "FLEXIHPC_KEYFILE"

flavor_id   = "ee55c523-9803-4296-91be-1c34e986baaa"
image_id    = "a5c9b7b2-e77b-4094-99ac-db0cf5181da5"
vm_user     = "ubuntu"
```

`FLEXIHPC_USER` is set to your username for the FlexiHPC Platform

`FLEXIHPC_PROJECT_NAME` is the project name

`FLEXIHPC_KEYPAIR_NAME` is your `Key Pair` name that is setup in FlexiHPC

`FLEXIHPC_KEYFILE` is the local location for your ssh key

The below config will setup the `s3` backend and use FlexiHPC's object storage to store the Terraform state file.

Inside the `provider.tf` file is some additional user configuration
```
  backend "s3" {
    bucket = "terraform-state"
    key    = "state/terraform.tfstate"
    endpoint   = "https://object.akl-1.cloud.nesi.org.nz/"
    sts_endpoint = "https://object.akl-1.cloud.nesi.org.nz/"
    access_key = "<EC2 User Access Token>"
    secret_key = "<EC2 User Secret Token>"
    #region = "us-east-1"
    force_path_style = "true"
    skip_credentials_validation = "true"
  }
```
`EC2 User Access Token` needs to be replaced with your EC2 users Access token

`EC2 User Secret Token` needs to be replaced with your EC2 users secret token

If you dont have any EC2 credentials then use the following CLI command to generate new ones
```
openstack ec2 credentials create
```
You can also list your EC2 credentials with the following CLI command
```
openstack ec2 credentials list
```

## Example run without creating and destruction in a single script

With these values updated you should be able to run the following commands to setup the environment
```
terraform init
terraform apply
```
This will ask for your FlexiHPC password before it does its plan stage for Terraform

Once you are done with the environment running the following command will destroy the environment
```
terraform destroy
```

## Example run with creating and destruction in a single script

Running the following script will create the enivronment with Terraform, Ping the servers from the Ansible `host.ini` file and if there is a response from all servers then it will drestroy the environment
```
./apply_and_destroy.sh
```
