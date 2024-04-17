resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.cluster_vpc.id
  service_name      = "com.amazonaws.${var.region}.s3"
  route_table_ids   = [aws_route_table.private_route.id]
  vpc_endpoint_type = "Gateway"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::*",
      "Principal": "*",
			"Condition": {
				"IpAddress": {
					"aws:VpcSourceIp": "${aws_vpc.cluster_vpc.cidr_block}"
				}
			}
    }
  ]
}
POLICY
  tags = {
    Name = "app-vpce-s3"
  }
}

