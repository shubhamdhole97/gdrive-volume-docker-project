output "instance_public_ips" {
  value = [for instance in aws_instance.ubuntu_instances : instance.public_ip]
}
