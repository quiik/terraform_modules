resource "aws_security_group" "my_sg" {
  count       = length(var.sg)
  vpc_id      = var.vpc_id
  dynamic "ingress" {
    for_each = var.sg[count.index]["ingress"]
    content {
        from_port       = ingress.value["from_port"]
        to_port         = ingress.value["to_port"]
        protocol        = ingress.value["protocol"]
        cidr_blocks     = ingress.value["cidr"]
        }
    }

  dynamic "egress" {
    for_each = var.sg[count.index]["egress"]
    content {
        from_port       = egress.value["from_port"]
        to_port         = egress.value["to_port"]
        protocol        = egress.value["protocol"]
        cidr_blocks     = egress.value["cidr"]
        }
    }

  tags = {
      Name = element(var.security_group, count.index)
  }
}