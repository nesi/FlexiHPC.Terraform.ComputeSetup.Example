variable "user_name" {
  description = "FlexiHPC username"
}

variable "tenant_name" {
  description = "FlexiHPC project Name"
}

variable "password" {
  description = "FlexiHPC password"
  type        = string
  sensitive   = true
}
variable "auth_url" {
  description = "FlexiHPC authentication URL"
}

variable "region" {
  description = "FlexiHPC region"
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
}