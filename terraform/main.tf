# Create a compute
resource "openstack_compute_instance_v2" "compute_instance" {
  count = var.instance_count

  name            = "compute-node-${count.index}"
  flavor_id       = var.flavor_id
  image_id        = var.image_id
  key_pair        = var.key_pair
  security_groups = ["SSH All"]

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

# Generate ansible host.ini file
locals {
  host_ini_content = templatefile("${path.module}/templates/host.ini.tpl", {
    instance_count = var.instance_count,
    floating_ips   = openstack_networking_floatingip_v2.floating_ip[*].address,
    vm_private_key_file = var.key_file
  })
}

resource "local_file" "host_ini" {
  filename = "../host.ini"
  content  = local.host_ini_content
}
