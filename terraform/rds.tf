resource "aws_db_subnet_group" "example" {
  name       = "dclass-db-subnet-group"
  subnet_ids = tolist(aws_subnet.public.*.id)
}

resource "aws_db_option_group" "example" {
  name                 = "dclass-db-option-group"
  engine_name          = "mysql"
  major_engine_version = "8.0"
}

resource "aws_security_group" "db_instance" {
  name   = var.db_name
  vpc_id = aws_vpc.cluster_vpc.id

  ingress {
    from_port   = "3306"
    to_port     = "3306"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "example" {
  identifier             = var.db_name
  engine                 = "mysql"
  engine_version         = "8.0.35"
  port                   = "3306"
  username               = var.db_username
  password               = var.db_password
  instance_class         = "db.t3.micro"
  allocated_storage      = "20"
  skip_final_snapshot    = true
  license_model          = "general-public-license"
  db_subnet_group_name   = aws_db_subnet_group.example.id
  vpc_security_group_ids = [aws_security_group.db_instance.id]
  publicly_accessible    = true
  option_group_name      = aws_db_option_group.example.id
}