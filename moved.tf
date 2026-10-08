moved {
  from = aws_vpc.cloudforge
  to   = module.vpc.aws_vpc.cloudforge
}

moved {
  from = aws_subnet.public_a
  to   = module.vpc.aws_subnet.public_a
}

moved {
  from = aws_subnet.public_b
  to   = module.vpc.aws_subnet.public_b
}

moved {
  from = aws_subnet.private_a
  to   = module.vpc.aws_subnet.private_a
}

moved {
  from = aws_subnet.private_b
  to   = module.vpc.aws_subnet.private_b
}

moved {
  from = aws_internet_gateway.cloudforge
  to   = module.vpc.aws_internet_gateway.cloudforge
}

moved {
  from = aws_route_table.public
  to   = module.vpc.aws_route_table.public
}

moved {
  from = aws_route.public_internet
  to   = module.vpc.aws_route.public_internet
}

moved {
  from = aws_route_table_association.public_a
  to   = module.vpc.aws_route_table_association.public_a
}

moved {
  from = aws_route_table_association.public_b
  to   = module.vpc.aws_route_table_association.public_b
}

moved {
  from = aws_eip.nat
  to   = module.vpc.aws_eip.nat
}

moved {
  from = aws_nat_gateway.cloudforge
  to   = module.vpc.aws_nat_gateway.cloudforge
}

moved {
  from = aws_route_table.private_a
  to   = module.vpc.aws_route_table.private_a
}

moved {
  from = aws_route.private_a_nat
  to   = module.vpc.aws_route.private_a_nat
}

moved {
  from = aws_route_table_association.private_a
  to   = module.vpc.aws_route_table_association.private_a
}

moved {
  from = aws_route_table.private_b
  to   = module.vpc.aws_route_table.private_b
}

moved {
  from = aws_route.private_b_nat
  to   = module.vpc.aws_route.private_b_nat
}

moved {
  from = aws_route_table_association.private_b
  to   = module.vpc.aws_route_table_association.private_b
}
