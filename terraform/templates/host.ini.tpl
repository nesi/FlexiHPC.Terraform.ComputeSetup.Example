[servers]
%{ for index in range(instance_count) ~}
compute-node-${index} ansible_host=${floating_ips[index]}
%{ endfor ~}

[servers:vars]
vm_private_key_file=${vm_private_key_file}
ansible_ssh_common_args="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"