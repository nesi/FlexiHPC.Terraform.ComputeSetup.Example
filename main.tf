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

# Generate ansible host.ini file
locals {
  host_ini_content = templatefile("${path.module}/templates/host.ini.tpl", {
    instance_count = var.instance_count,
    floating_ips   = openstack_networking_floatingip_v2.floating_ip[*].address,
  })
}

resource "local_file" "host_ini" {
  filename = "ansible/host.ini"
  content  = local.host_ini_content
}

resource "null_resource" "wait_for_compute" {
  depends_on = [openstack_compute_instance_v2.compute_instance]

  # Introduce a delay using the local-exec provisioner.
  provisioner "local-exec" {
    command = "sleep 10"  # Wait for 300 seconds (5 minutes) in this example.
  }
}

# Run anisble playbook
resource "null_resource" "run_ansible_playbook" {
  depends_on = [local_file.host_ini, null_resource.wait_for_compute]

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ansible/host.ini ansible/ping_test.yml -u ${var.vm_user} --key-file '${var.key_file}'"
    working_dir = path.module
  }
}