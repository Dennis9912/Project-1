# Configure Security group for Application Load Balancer
resource "aws_security_group" "practice_alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP and HTTPS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-alb-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.practice_alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.practice_alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.practice_alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# Configure Target Group for Alb
resource "aws_lb_target_group" "practice_target_group" {
  name     = "target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

    health_check {
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200,301,302"
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

# Configure Application Load Balancer [ALB]
resource "aws_lb" "practice_alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.practice_alb_sg.id]
  subnets            = [var.public_subnet_az_1a, var.public_subnet_az_1b]

  enable_deletion_protection = false

  tags = merge(var.tags, {
	Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-alb"
	})
}

# Configure a listener on Port 443 with SSL certificate and default action [HTTP]
resource "aws_lb_listener" "practice_alb_redirect_action" {
  load_balancer_arn = aws_lb.practice_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Configure a listener on Port 80 with redirect action [HTTPS]
resource "aws_lb_listener" "practice_alb_forward_action" {
  load_balancer_arn = aws_lb.practice_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.practice_target_group.id
  }
}