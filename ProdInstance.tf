#Creating instance for each services seperately for security and redundancy

resource "aws_instance" "jenkins" {
  ami = "ami-07c8c1b18ca66bb07"
  //count = 2
  instance_type = var.instance_type
  #vpc_security_group_ids = [data.aws_security_group.launch_wizard_1.id]
  subnet_id              = aws_subnet.public1.id
  vpc_security_group_ids = [aws_security_group.JenkinsSG.id]
  key_name               = "testpair"

  root_block_device {
    volume_size = var.Instance_volume
    volume_type = var.Instance_volume_type
  }

  tags = {
    Name = var.prod-jenkins-instance
  }
}

resource "aws_instance" "SAST" {
  ami = "ami-07c8c1b18ca66bb07"
  //count = 2
  instance_type = var.instance_type
  #vpc_security_group_ids = [data.aws_security_group.launch_wizard_1.id]
  subnet_id              = aws_subnet.public1.id
  vpc_security_group_ids = [aws_security_group.SASTsg.id]
  key_name               = "testpair"

  root_block_device {
    volume_size = var.Instance_volume
    volume_type = var.Instance_volume_type
  }

  tags = {
    Name = var.prod-SAST-instance
  }
}

resource "aws_instance" "Monitoring" {
  ami = "ami-07c8c1b18ca66bb07"
  //count = 2
  instance_type = var.instance_type
  #vpc_security_group_ids = [data.aws_security_group.launch_wizard_1.id]
  subnet_id              = aws_subnet.public1.id
  vpc_security_group_ids = [aws_security_group.Monitoringsg.id]
  key_name               = "testpair"

  root_block_device {
    volume_size = var.Instance_volume
    volume_type = var.Instance_volume_type
  }

  tags = {
    Name = var.prod-monitoring-instance
  }
}