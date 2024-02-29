[servers]
%{ for index in range(instance_count) ~}
compute-node-${index} ansible_host=${floating_ips[index]}
%{ endfor ~}