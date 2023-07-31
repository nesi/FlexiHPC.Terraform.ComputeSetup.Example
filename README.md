# FlexiHPC.Terraform.ComputeSetup.Example

This example repo is to demonstrate setting up compute services within the FlexiHPC platform using Terraform.

[Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) and [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/index.html) needs to be installed on your system to use this example.

It also provides different examples of where to run Anisble if the user so wishes.

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