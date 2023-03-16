output "aws_default_vpc" {
  value = data.aws_vpc.default.id
}

# output "subnets" {
#   value = data.aws_subnets.default.ids
# }

output "subnet_selected" {
  value = data.aws_subnet.selected.id
}

output "key_pair" {
  value = resource.aws_key_pair.deployer.key_name
}

output "security_group_id" {
  value = module.security_group.security_group_id
}

output "ip_address" {
  value = module.ec2_instance.public_ip
}
