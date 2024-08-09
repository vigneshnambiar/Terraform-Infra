#Creating an instance for the testing

resource "aws_instance" "web" {
  ami = "ami-07c8c1b18ca66bb07"
  //count = 2
  instance_type = var.instance_type
  #vpc_security_group_ids = [data.aws_security_group.launch_wizard_1.id]
  subnet_id              = aws_subnet.public1.id
  vpc_security_group_ids = [aws_security_group.Dev-Test-SG.id]
  key_name               = "testpair"

  root_block_device {
    volume_size = var.Instance_volume
    volume_type = var.Instance_volume_type
  }

  tags = {
    Name = var.devpy-instance
  }
}