# Gather existing SGs data base on group-name and "Name = frankfurt-sg" tag.
# This tag is used to avoid SGs with same name.
# Given list of SGs should be on same VPC
data "aws_security_groups" "selected" {
  filter {
    name   = "group-name"
    values = [for item in var.instance.vpc_security_group_name : item]
  }
  tags = {
    usage = "terraform"
  }
}


# Find a VPC subnet_ids by Name
# Get first vpc_id by "data.aws_security_groups.selected.vpc_ids[0]".
# Assumption is that all VPC_IDs are the same.
data "aws_subnet_ids" "selected" {
  vpc_id = data.aws_security_groups.selected.vpc_ids[0]
  tags = {
    Name = var.instance.subnet_name
  }
}

# Following block is to avoid instance recreation.
data "aws_subnet" "selected" {
  count = 1
  id    = join("", data.aws_subnet_ids.selected.ids)
}

resource "aws_iam_role" "s3_role" {
  name = "s3_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    usage = "terraform"
  }
}


resource "aws_iam_instance_profile" "s3_access_profile" {
  name = "s3_access_profile"
  role = aws_iam_role.s3_role.name
}

resource "aws_iam_role_policy" "s3_policy" {
  name = "s3_policy"
  role = aws_iam_role.s3_role.name
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_instance" "ec2" {
  count                       = var.instance.count
  ami                         = var.instance.ami
  private_ip                  = var.instance.private_ip[count.index]
  instance_type               = var.instance.instance_type
  subnet_id                   = data.aws_subnet.selected[0].id
  iam_instance_profile        = aws_iam_instance_profile.s3_access_profile.name
  key_name                    = var.instance.key_name
  monitoring                  = var.instance.monitoring
  vpc_security_group_ids      = data.aws_security_groups.selected.ids
  associate_public_ip_address = var.instance.associate_public_ip_address
  root_block_device           {
    volume_type = var.instance.root_block_device.volume_type
    volume_size = var.instance.root_block_device.volume_size
  }

  volume_tags = merge(
    var.default_tags, {
      "Name" = join(".", [format("%s%02d", var.instance.category, count.index + 1), var.instance.environment])
    },
  )

  tags        = merge(
    var.instance.tags,
    var.default_tags,
    {"Name" = join(".", [format("%s%02d", var.instance.category, count.index + 1), var.instance.environment])},
  )

  lifecycle {
    ignore_changes = [
      user_data,
      associate_public_ip_address,
      private_ip,
      root_block_device,
      ebs_block_device,
    ]
  }



  provisioner "file" {
    source      = "../Ansible/inventory"
    destination = "/home/ubuntu/inventory"
    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/afshingolang-production.pem")
    }
  }

  provisioner "file" {
    source      = "../Ansible/script.sh"
    destination = "/tmp/script.sh"
    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/afshingolang-production.pem")
    }
  }

  provisioner "file" {
    source      = "../Ansible/first.yml"
    destination = "/home/ubuntu/first.yaml"
    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/afshingolang-production.pem")
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh",
    ]
    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/afshingolang-production.pem")
    }
  }

  provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok --instance-ids ${self.id} && ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i '${self.public_ip}', ../Ansible/first.yml"
    on_failure  = continue
    environment = {
      name = self.tags["Name"]
      ssh = "ssh -A ubuntu@${self.public_ip}"
    }
  }

  provisioner "remote-exec" {
    inline = ["eval $(ssh-agent -s)", 
      "ssh-add ~/.ssh/afshingolang-production.pem",
      "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i inventory ~/Terraform_Ansible_Demo/Ansible/mongo-replicaset/site.yml"]
    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/afshingolang-production.pem")
    }
  }

}

# If associate_eip_address true then will Associate an EIP to instance 
resource "aws_eip" "assosiate" {
  count    = var.instance.associate_eip_address ? var.instance.count : 0

  instance = aws_instance.ec2[count.index].id

  tags = merge(
    var.instance.tags,
    var.default_tags,
    {"Name" = join(".", [format("%s%02d", var.instance.category, count.index + 1), var.instance.environment])},
  )
}
