locals {
  name = "pritunl-vm"
}

data "aws_vpc" "default" {
  default = true
}

# data "aws_subnets" "default" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.default.id]
#   }
# }

data "aws_subnet" "selected" {
  filter {
    name   = "availability-zone"
    values = ["us-east-1a"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.key_pair_public_key
}

module "security_group" {
  source = "../../modules/security-group"

  name        = "pritunl-vm-sg"
  description = "Pritunl VM Security Groups"
  vpc_id      = data.aws_vpc.default.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules = [
    "ssh-tcp",
    "https-443-tcp",
    "http-80-tcp",
  ]

  ingress_with_cidr_blocks = [
    {
      from_port   = "1191"
      to_port     = "1199"
      protocol    = "TCP"
      description = "Pritunl - OVPN:TCP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = "1191"
      to_port     = "1199"
      protocol    = "UDP"
      description = "Pritunl - OVPN:UDP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = "51820"
      to_port     = "51829"
      protocol    = "UDP"
      description = "Pritunl - WG:UDP"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_rules = ["all-all"]

}

## Disabled in favour to `source_dest_check` option
# resource "aws_iam_role" "ssm" {
#   name = local.name
#   assume_role_policy = <<-EOT
#   {
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Action": "sts:AssumeRole",
#         "Principal": {
#           "Service": "ec2.amazonaws.com"
#         },
#         "Effect": "Allow",
#         "Sid": ""
#       }
#     ]
#   }
#   EOT
#   managed_policy_arns = [
#     "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
#   ]
# }

# resource "aws_iam_instance_profile" "ssm" {
#   name = local.name
#   role = aws_iam_role.ssm.name
# }


## Disabled for Fixed AMI
# data "aws_ami" "ubuntu" {
#   most_recent = true
#   owners      = ["099720109477"]

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }

data "template_file" "pritunl_app" {
  template = file("${path.module}/userdata.sh")

  vars = {
    atlas_dbuser                   = var.atlas_dbuser
    atlas_dbpassword               = var.atlas_dbpassword
    atlas_server_authority_address = var.atlas_server_authority_address
    pritunl_database               = var.pritunl_database

  }
}

module "ec2_instance" {
  source = "../../modules/ec2-instance"

  for_each = toset(["1", "2"])

  name = "${local.name}-${each.key}"

  # ami                    = data.aws_ami.ubuntu.id
  ami                    = "ami-0557a15b87f6559cf"
  instance_type          = "t2.micro"
  key_name               = resource.aws_key_pair.deployer.key_name
  monitoring             = true
  vpc_security_group_ids = [module.security_group.security_group_id]
  subnet_id              = data.aws_subnet.selected.id

  ## Disabled in favour to `source_dest_check` option
  # iam_instance_profile        = aws_iam_instance_profile.ssm.name

  user_data_base64            = base64encode(data.template_file.pritunl_app.rendered)
  user_data_replace_on_change = true
  associate_public_ip_address = true

  source_dest_check = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Host        = "${local.name}"
  }
}
