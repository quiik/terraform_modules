resource aws_vpc_endpoint "myend" {
  count              = length(var.endpoint)
  vpc_id             = aws_vpc.vpc.id

  vpc_endpoint_type  = lookup(var.endpoint[count.index], "type")
  service_name       = lookup(var.endpoint[count.index], "service_name")
  security_group_ids = [aws_security_group.myend[count.index].id]
  
  policy = <<EOF
{
  "Statement": [
    {
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*",
      "Principal": "*"
    }
  ]
}
  EOF
  tags = {
    Name = lookup(var.endpoint[count.index], "name")
  }
}

resource "aws_security_group" "myend"{
  count       = length(var.endpoint)
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port       = lookup(var.endpoint[count.index], "from_port")
    to_port         = lookup(var.endpoint[count.index], "to_port")
    protocol        = "tcp"
    cidr_blocks     = [var.cidr_block]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
      Name = "my-endpoint-sg"
  }
}