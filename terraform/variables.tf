variable "user_name" {
  description = "FlexiHPC username"
}

variable "tenant_name" {
  description = "FlexiHPC project Name"
}

variable "auth_url" {
  description = "FlexiHPC authentication URL"
  default = "https://keystone.akl-1.cloud.nesi.org.nz/v3"
}

variable "region" {
  description = "FlexiHPC region"
  default = "akl-1"
}

variable "instance_count" {
  description = "Number of compute instances to create"
  default     = 1
}

variable "key_pair" {
  description = "FlexiHPC Key Pair name"
}

variable "key_file" {
  description = "FlexiHPC Key Pair name"
}

variable "flavor_id" {
  description = "FlexiHPC Flavor ID, Defaults to devtest1.1cpu1ram"
  default     = "ee55c523-9803-4296-91be-1c34e986baaa" 
}

variable "image_id" {
  description = "FlexiHPC Image ID, Defaults to Ubuntu-Jammy-22.04"
  default     = "a5c9b7b2-e77b-4094-99ac-db0cf5181da5" 
}

variable "vm_user" {
  description = "FlexiHPC VM user"
  default = "ubuntu"
}

variable "extra_public_keys" {
  description = "Additional SSH public keys to add to the authorized_keys file on provisioned nodes"
  type = list(string)
  default = []
}
