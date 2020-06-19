variable "region" {
  default = "cn-hangzhou"
}

variable "profile" {
  default = "default"
}

provider "alicloud" {
  region  = var.region
  profile = var.profile
}

#####################
# Create vpc, nat-gateway and bind eip and add snat, dnat
#####################
module "vpc-nat" {
  source  = "../.."
  region  = var.region
  profile = var.profile

  create_vpc = true
  vpc_name   = "my-env-vpc"
  vpc_cidr   = "10.10.0.0/16"

  availability_zones = ["cn-hangzhou-e", "cn-hangzhou-f", "cn-hangzhou-g"]
  vswitch_cidrs      = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]

  vpc_tags = {
    Owner       = "user"
    Environment = "staging"
    Name        = "complete"
  }

  vswitch_tags = {
    Project  = "Secret"
    Endpoint = "true"
  }

  // common bandwidth package
  cbp_bandwidth = 10
  cbp_ratio     = 100

  // nat_gateway
  create_nat = true
  nat_name   = "nat-gateway-foo"

  // eip
  create_eip = true
  eip_name   = "eip-nat-foo"

  // create eip, snat and bind eip with vswitch_cidrs
  create_snat        = true
  number_of_snat_eip = 3

  // create eip, snat and bind eip with instance
  create_dnat        = true
  number_of_dnat_eip = 1
  dnat_entries = [
    {
      name          = "dnat-443-8443"
      ip_protocol   = "tcp"
      external_port = "443"
      internal_port = "8443"
      internal_ip   = concat(module.ecs-instance.this_private_ip, [""])[0]
    }
  ]
}

#####################
# add dnat
#####################
data "alicloud_images" "ubuntu" {
  name_regex = "ubuntu_18"
}

module "group" {
  source  = "alibaba/security-group/alicloud"
  region  = var.region
  profile = var.profile

  name   = "dnat-service"
  vpc_id = module.vpc-nat.this_vpc_id
}

module "ecs-instance" {
  source  = "alibaba/ecs-instance/alicloud"
  region  = var.region
  profile = var.profile

  number_of_instances = 1

  name                        = "my-ecs-cluster"
  use_num_suffix              = true
  instance_type               = "ecs.mn4.small"
  image_id                    = data.alicloud_images.ubuntu.ids.0
  vswitch_ids                 = module.vpc-nat.this_vswitch_ids
  security_group_ids          = [module.group.this_security_group_id]
  associate_public_ip_address = false

  system_disk_category = "cloud_ssd"
  system_disk_size     = 50
}