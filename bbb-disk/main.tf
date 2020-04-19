resource "aws_ebs_volume" "disk" {
  availability_zone = "eu-west-1a"
  size              = 40

  tags = {
    Name = var.disk_name
  }
}