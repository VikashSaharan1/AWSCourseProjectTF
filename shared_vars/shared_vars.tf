output "vpcid" {
  value = local.vpcid
}

output "publicsubnetid1" {
  value = local.publicsubnetid1
}

output "publicsubnetid2" {
  value = local.publicsubnetid2
}

output "privatesubnetid" {
  value = local.privatesubnetid
}

output "env_suffix" {
  value = local.env_suffix
}



locals {
   env = terraform.workspace
   vpcid_env = {
     default = "vpc-74dd671f"
     staging = "vpc-74dd671f"
     production = "vpc-74dd671f"
   }

    env_suffix_env = {
    default = "staging",
    staging = "staging",
    production = "production"
  }

   env_suffix = lookup(local.env_suffix_env, local.env)

   vpcid = lookup(local.vpcid_env, local.env)


   publicsubnetid1_env = {
     default = "subnet-91ba18fa"
     staging = "subnet-91ba18fa"
     production = "subnet-91ba18fa"
   }

   publicsubnetid1 = lookup(local.publicsubnetid1_env, local.env)

   publicsubnetid2_env = {
     default = "subnet-66f0b02a"
     staging = "subnet-66f0b02a"
     production = "subnet-66f0b02a"
   }

   publicsubnetid2 = lookup(local.publicsubnetid2_env, local.env)


   privatesubnetid_env = {
     default = "subnet-56d2ca2c"
     staging = "subnet-56d2ca2c"
     production = "subnet-56d2ca2c"
   }

   privatesubnetid = lookup(local.privatesubnetid_env, local.env)

}