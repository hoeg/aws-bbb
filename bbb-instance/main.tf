data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

resource "aws_instance" "box" {
    ami           = data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    key_name = aws_key_pair.deployer.key_name
    user_data = file("${path.module}/install.sh")
    availability_zone = "eu-west-1a"

    network_interface {
        network_interface_id = aws_network_interface.main.id
        device_index = 0
    }

    tags = {
        Name = "BugBountyBox"
        Terraform = true
    }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = data.aws_ebs_volume.hax_volume.id
  instance_id = aws_instance.box.id
}

data "aws_ebs_volume" "hax_volume" {
  most_recent = true

  filter {
    name   = "tag:Name"
    values = [var.disk_name]
  }
}

resource "aws_network_interface" "main" {
  subnet_id       = aws_subnet.main.id
  security_groups = [aws_security_group.bb_ports.id]
}

resource "aws_key_pair" "deployer" {
  key_name   = "working-key"
  public_key = file("${path.module}/../bbb-access.key.pub")
}

output "public_ip" {
    value = aws_instance.box.public_ip
}