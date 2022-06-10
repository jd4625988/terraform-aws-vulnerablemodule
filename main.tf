terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.18.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "network" {
  source       = "./modules/network"
  environment  = var.environment
  default_tags = var.default_tags
}

module "storage" {
  source         = "./modules/storage"
  private_subnet = module.network.private_subnet
  vpc_id         = module.network.vpc_id
  environment    = var.environment
  default_tags   = var.default_tags
  db_username    = var.db_username
  db_password    = var.db_password
}

resource "local_file" "web-access" {
  content  = <<JSON
{
  "fqdn": "${module.network.elb_url}"
}
  JSON
  filename = "./web-access.json"
}
