resource aws_nat_gateway nat_gateway {
  count = local.number_of_nat_gateways

  allocation_id = aws_eip.nat_gateway.*.id[count.index]
  subnet_id     = module.external_vpc.zone_subnet_ids[count.index]

  tags = merge(
    var.tags,
    map(
      "Name", format("%s-%s.%s", "nat-gateway", count.index + 1, module.meta.name_suffix),
      "AZ", element(data.aws_availability_zones.available.names, count.index),
    )
  )
}

resource aws_eip nat_gateway {
  count = local.number_of_nat_gateways
  vpc   = true

  tags = merge(
    var.tags,
    map(
      "Name", format("%s-%s.%s", "nat-gateway", count.index + 1, module.meta.name_suffix),
      "AZ", element(data.aws_availability_zones.available.names, count.index),
    )
  )
}