module "shared_vars" {
  source = "../shared_vars"
}


resource "aws_security_group" "publicsg" {
  name        = "publicsg_${module.shared_vars.env_suffix}"
  description = "publicsg for load balancer in ${module.shared_vars.env_suffix}"
  vpc_id      =  module.shared_vars.vpcid

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "publicsg_${module.shared_vars.env_suffix}"
  }
}


output "publicsg_id" {
  value = aws_security_group.publicsg.id
}

resource "aws_security_group" "privatesg" {
  name        = "privatesg_${module.shared_vars.env_suffix}"
  description = "privatesg for ssh in ${module.shared_vars.env_suffix}"
  vpc_id      =  module.shared_vars.vpcid

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = ["${aws_security_group.publicsg.id}"]
  }

  egress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  tags = {
    Name = "privatesg_${module.shared_vars.env_suffix}"
  }
}

output "privatesg_id" {
  value = aws_security_group.privatesg.id
}
