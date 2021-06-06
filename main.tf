terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
  profile = "vikash-terraform"
}


module "network_module" {
  source = "./network_module"
}



module "loadbalancer_module" {
  source = "./loadbalancer_module"
  publicsg_id = "${module.network_module.publicsg_id}"
}


module "autoscaling_module" {
  source = "./autoscaling_module"
  privatesg_id = "${module.network_module.privatesg_id}"
  tg_arn = "${module.loadbalancer_module.tg_arn}"
}

