variable "privatesg_id" {}
variable "tg_arn" {}

module "shared_vars" {
  source = "../shared_vars"
}



locals {
   env = terraform.workspace
   amiid_env = {
     default = "ami-077e31c4939f6a2f3"
     staging = "ami-077e31c4939f6a2f3"
     production = "ami-077e31c4939f6a2f3"
   }

   amiid = lookup(local.amiid_env, local.env)

   instancetype_env = {
     default = "t2.micro"
     staging = "t2.micro"
     production = "t2.medium"
   }

   instancetype = lookup(local.instancetype_env, local.env)

   keypairname_env = {
     default = "aws_project_tf_staging"
     staging = "aws_project_tf_staging"
     production = "aws_project_tf_production"
   }

   keypairname = lookup(local.keypairname_env, local.env)


   asgdesired_env = {
     default = "1"
     staging = "1"
     production = "2"
   }

   asgdesired = lookup(local.asgdesired_env, local.env)


   asgmin_env = {
     default = "1"
     staging = "1"
     production = "2"
   }

   asgmin = lookup(local.asgmin_env, local.env)

   asgmax_env = {
     default = "2"
     staging = "2"
     production = "4"
   }

   asgmax = lookup(local.asgmax_env, local.env)

}

resource "aws_launch_configuration" "sampleapp_lc" {
  name          = "sampleapp_lc_${local.env}"
  image_id      = "${local.amiid}"
  instance_type = "${local.instancetype}"
  key_name = "${local.keypairname}"
  user_data = "${file("assets/userdata.txt")}"
  security_groups = ["${var.privatesg_id}"]
}

resource "aws_autoscaling_group" "sampleapp_asg" {
  name                 = "sampleapp_asg_${local.env}"
  max_size             = local.asgmax
  min_size             = local.asgmin
  desired_capacity     = local.asgdesired
  launch_configuration = aws_launch_configuration.sampleapp_lc.name
  vpc_zone_identifier  = ["${module.shared_vars.publicsubnetid1}"]
  target_group_arns    =  ["${var.tg_arn}"]

  tags = [
      {
        "key"                 = "Name"
        "value"               = "SampleApp_${local.env}"
        "propagate_at_launch" = true
      },
      {
        "key"                 = "Environment"
        "value"               = "${local.env}"
        "propagate_at_launch" = true
      },
    ]
}
    