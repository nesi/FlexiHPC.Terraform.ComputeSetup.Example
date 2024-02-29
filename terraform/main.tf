# Create a compute
resource "openstack_compute_instance_v2" "compute_instance" {
  count = var.instance_count

  name            = "compute-node-${count.index}"
  flavor_id       = var.flavor_id
  image_id        = var.image_id
  key_pair        = var.key_pair
  security_groups = ["SSH Allow All"]

  network {
    name = var.tenant_name
  }
}

# Create floating ip
resource "openstack_networking_floatingip_v2" "floating_ip" {
  count = var.instance_count
  pool  = "external"
}

# Assign floating ip
resource "openstack_compute_floatingip_associate_v2" "floating_ip_association" {
  for_each     = { for idx, ip in openstack_networking_floatingip_v2.floating_ip : idx => ip }
  floating_ip  = each.value.address
  instance_id  = openstack_compute_instance_v2.compute_instance[each.key].id
}

# add extra public keys to the instance
resource "null_resource" "github_runner_extra_keys" {
  depends_on = [openstack_compute_floatingip_associate_v2.github_runner_floating_ip_association]
  count = length(var.extra_public_keys) > 0 ? 1 : 0

  connection {
    user = var.vm_user
    private_key = file(var.key_file)
    host = "${openstack_networking_floatingip_v2.github_runner_floating_ip.address}"
  }

  provisioner "remote-exec" {
    inline = [for pkey in var.extra_public_keys : "echo ${pkey} >> $HOME/.ssh/authorized_keys"]
  }
}

# Generate ansible host.ini file
locals {
  host_ini_content = templatefile("${path.module}/templates/host.ini.tpl", {
    instance_count = var.instance_count,
    floating_ips   = openstack_networking_floatingip_v2.floating_ip[*].address,
  })
}

resource "local_file" "host_ini" {
  filename = "../host.ini"
  content  = local.host_ini_content
}
