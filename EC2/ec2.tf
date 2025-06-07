#Configure Security group for frontend Servers
resource "aws_security_group" "apci_frontend_server_sg" {
  name        = "frontend-server-sg"
  description = "Allow ssh, http and https inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
	Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-frontend-server-sg"
	})
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.apci_frontend_server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
} 

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.apci_frontend_server_sg.id
  referenced_security_group_id = var.alb_sg
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.apci_frontend_server_sg.id
  referenced_security_group_id = var.alb_sg
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.apci_frontend_server_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

#Configure Launch template for frontend servers
resource "aws_launch_template" "apci_launch_template" {
  name          = "apci-launch-lemplate"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  user_data     = base64encode(file("scripts/frontend-server.sh"))

    network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.apci_frontend_server_sg.id]
  }
  
  tag_specifications {
    resource_type = "instance"
    tags = merge(var.tags, {
	Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-frontend-servers"
	})
  }
}

#Configure Auto Scaling Group
resource "aws_autoscaling_group" "apci_asg" {
  name                      = "asg"
  max_size                  = 4
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  target_group_arns         = [var.target_group_arns]
  vpc_zone_identifier       = [var.public_subnet_az_1a, var.public_subnet_az_1b]

  launch_template {
    id      = aws_launch_template.apci_launch_template.id
    version = "$Latest"
  }
}