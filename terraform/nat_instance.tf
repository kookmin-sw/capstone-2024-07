module "nat" {
  source = "int128/nat-instance/aws"

  name                        = "main"
  vpc_id                      = aws_vpc.cluster_vpc.id
  public_subnet               = aws_subnet.public[0].id
  private_subnets_cidr_blocks = aws_subnet.private[*].cidr_block
  private_route_table_ids     = [aws_route_table.private_route.id]
}

resource "aws_eip" "nat" {
  network_interface = module.nat.eni_id
  tags = {
    "Name" = "nat-instance-main"
  }
}