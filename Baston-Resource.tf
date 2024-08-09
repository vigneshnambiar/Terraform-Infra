#Enable this if wnat to try the BastonHost method



# #Creating the resources for the project
# # data "aws_security_group" "launch_wizard_1" {
# #   filter {
# #     name   = "group-name"
# #     values = ["launch-wizard-1"]
# #   }
# # }


# resource "aws_instance" "web" {
#   ami = "ami-07c8c1b18ca66bb07"
#   //count = 2
#   instance_type = "t3.micro"
#   #vpc_security_group_ids = [data.aws_security_group.launch_wizard_1.id]
#   subnet_id              = aws_subnet.public1.id
#   vpc_security_group_ids = [aws_security_group.BastonHoste.id]
#   key_name               = "testpair"

#   tags = {
#     Name = var.instance_tag
#   }
# }

# #private

# resource "aws_instance" "web-private" {
#   ami = "ami-07c8c1b18ca66bb07"
#   //count = 2
#   instance_type = "t3.micro"
#   #vpc_security_group_ids = [data.aws_security_group.launch_wizard_1.id]
#   # subnet_id              = aws_subnet.private1.id
#   # vpc_security_group_ids = [aws_security_group.privatesg.id]
#   # key_name               = "testpair"

#   tags = {
#     Name = var.instance_tag2
#   }
# }