# Define required providers
terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.51.1"
    }
  }

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
}

# Configure the OpenStack Provider
provider "openstack" {
  user_name   = var.user_name
  tenant_name = var.tenant_name
  password    = var.password
  auth_url    = var.auth_url
  region      = var.region
}
