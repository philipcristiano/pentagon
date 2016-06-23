// Sample main.tf

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region}"
}

module "vpc" {
  source = "git::ssh://git@github.com/reactiveops/terraform-vpc.git?ref=1.0.1"
  org_name = "${var.org_name}"

  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"
  aws_region = "${var.aws_region}"

  az_count =  "${var.az_count}"
  aws_azs = "${var.aws_azs}"

  network = "${var.vpc_cidr}"

  nat_gateway_enabled = 1

}