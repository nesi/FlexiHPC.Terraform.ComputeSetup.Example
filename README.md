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

## Configuration

You will need to configure the deployment by setting some environment variables:

```
export TF_VAR_key_pair="KEY_PAIR_NAME"
export TF_VAR_key_file="~/.ssh/location/to/key_pair"
export TF_VAR_vm_user="ubuntu"
export AWS_ACCESS_KEY_ID="<EC2_ACCESS_KEY>"
export AWS_SECRET_KEY="<EC2_SECRET_KEY>"
```

where

- `TF_VAR_key_pair` is the Key Pair name in NeSI RDC
- `TF_VAR_key_file` is the Key Pair location on your local machine
- `TF_VAR_vm_user` is the user for the RDC cloud image
- `AWS_ACCESS_KEY_ID` and `AWS_SECRET_KEY` are EC2 credentials created on the RDC, see
  [Creating and Managing EC2 credentials](https://support.cloud.nesi.org.nz/user-guides/create-and-manage-object-storage/creating-and-managing-ec2-credentials-via-cli/)

Within the *terraform* directory you will also need to set the bucket name under the file *terraform/provider.tf* on line 12.

You will also need to run the following command and make a copy of the *terraform.tfvars.example* and rename it to *terraform.tfvars*

```
cp terraform.tfvars.example terraform.tfvars
```

You will also need to ensure you have downloaded your *clouds.yaml* from the NeSI RDC and ensure it is located in *~/.config/openstack/*.

## Deployment

With the configuration step completed you can run `./deployment.sh create` to create the instance.

To destroy the instance run `./deployment.sh destroy`.
