resource aws_route external {
  count = var.number_of_availability_zones

  route_table_id = module.internal_zone.route_table_ids[count.index]
  gateway_id     = element(aws_nat_gateway.nat_gateway.*.id, count.index)

  destination_cidr_block = local.all_ip_addresses
}
