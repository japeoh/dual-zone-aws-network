locals {
  private_zone_name = var.with_internet_gateway ? "private" : "amber"
}

module meta {
  source = "github.com/japeoh/meta-tfmodule"

  name          = var.name
  environment   = var.environment
  organisation  = var.organisation
  domain_suffix = var.domain_suffix
  tags          = var.tags
}

module external_vpc {
  source = "github.com/japeoh/single-zone-vpc-tfmodule"

  role_arn                     = var.role_arn
  region                       = var.region
  name                         = var.name
  environment                  = var.environment
  organisation                 = var.organisation
  domain_suffix                = var.domain_suffix
  tags                         = var.tags
  vpc_cidr_block               = var.vpc_cidr_block
  with_ipv6_cidr_block         = var.with_ipv6_cidr_block
  with_internet_gateway        = var.with_internet_gateway
  with_private_r53_zone        = var.with_private_r53_zone
  with_vpc_flow_log            = var.with_vpc_flow_log
  number_of_availability_zones = var.number_of_availability_zones
  zone_cidr_block              = var.external_zone_cidr_block
  zone_ingress_cidr_block      = var.external_zone_ingress_cidr_block
  zone_egress_cidr_block       = var.external_zone_egress_cidr_block

}

module internal_zone {
  source = "github.com/japeoh/aws-zone-tfmodule"

  role_arn                     = var.role_arn
  region                       = var.region
  name                         = local.private_zone_name
  name_suffix                  = module.meta.name_suffix
  tags                         = merge(var.tags, module.meta.tags)
  vpc_id                       = module.external_vpc.vpc_id
  number_of_availability_zones = var.number_of_availability_zones
  cidr_block                   = var.internal_zone_cidr_block
  ingress_cidr_block           = var.vpc_cidr_block
  egress_cidr_block            = var.vpc_cidr_block
}
