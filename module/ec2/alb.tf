resource "aws_lb_target_group" "lb_targate" {
    count = terraform.workspace == "dev"? 1 : 0
  vpc_id = var.vpc_id
  port = 443
  protocol = "TLS"
  health_check {
    enabled = true
    #path = "/"
    interval = 5
    protocol = "TCP"
    unhealthy_threshold = 2
    healthy_threshold = 2
    #matcher = "200"
    timeout = 4
  }
  name = "tg-tls"
  target_type = "instance"

  tags = {
    Name = "tg-${var.Name}"
    Environment = var.Environment
  }
}

resource "aws_lb_target_group_attachment" "instance_attachment" {
  count = terraform.workspace == "dev"? 1 : 0
  target_group_arn = one(aws_lb_target_group.lb_targate[*].arn)
  target_id = one(aws_instance.private_server[*].id)
  
}

resource "aws_lb" "alb" {
    count = terraform.workspace == "dev"? 1 : 0
  internal = false
  ip_address_type = "ipv4"
  name = "network-lb"
  load_balancer_type = "network"
  security_groups = [ var.sg_id ]
  subnets = var.lb_subnet_id

    tags = {
    Name = "alb-${var.Name}"
    Environment = var.Environment
  }
}

resource "aws_lb_listener" "tls" {
    count = terraform.workspace == "dev"? 1 : 0
  load_balancer_arn = one(aws_lb.alb[*].arn)
  port              = "443"
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
  certificate_arn   = "arn:aws:acm:us-east-1:792625104377:certificate/c620d367-ca8e-4796-a51f-b9a10f6ac2a4"

  default_action {
    type             = "forward"
    target_group_arn = one(aws_lb_target_group.lb_targate[*].arn)
  }
}