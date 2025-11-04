#Groupe de sécurité bastion interface public
resource "aws_security_group" "security_group_bastion_public" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    Name = var.security_group_name_bastion
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.security_group_bastion_public.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port   = 22
  to_port     = 22
  ip_protocol    = "tcp"
}
#Groupe de sécurité bastion interface private 1
resource "aws_security_group" "security_group_bastion_private_1" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    Name = var.security_group_name_bastion
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_from_private_1" {
  security_group_id = aws_security_group.security_group_bastion_private_1.id
  cidr_ipv4 = "10.0.128.0/18"
  ip_protocol    = -1
}
#Groupe de sécurité bastion interface private 2
resource "aws_security_group" "security_group_bastion_private_2" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    Name = var.security_group_name_bastion
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_from_private_2" {
  security_group_id = aws_security_group.security_group_bastion_private_2.id
  cidr_ipv4 = "10.0.192.0/18"
  ip_protocol    = -1
}


#Groupe de sécurité allow all out
resource "aws_security_group" "security_group_all_egress" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    Name = var.security_group_name_all_egress
  }
}
resource "aws_vpc_security_group_egress_rule" "allow_all_out" {
  security_group_id = aws_security_group.security_group_all_egress.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}




#Groupe de sécurité back 
resource "aws_security_group" "security_group_back" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    Name = var.security_group_name_ssh_from_bastion
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_bastion_back" {
  security_group_id = aws_security_group.security_group_back.id
  cidr_ipv4 = "${aws_network_interface.bastion_interface_private_2.private_ip}/32"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}


#Groupe de sécurité front
resource "aws_security_group" "security_group_front" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    Name = var.security_group_name_front
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_bastion_front" {
  security_group_id = aws_security_group.security_group_front.id
  cidr_ipv4 = "${aws_network_interface.bastion_interface_private_1.private_ip}/32"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}
resource "aws_vpc_security_group_ingress_rule" "allow_http_from_loadbalancer" {
  security_group_id = aws_security_group.security_group_front.id
  cidr_ipv4 = "${aws_instance.loadbalancer.private_ip}/32"
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}
resource "aws_vpc_security_group_ingress_rule" "allow_rtmp_from_backend" {
  security_group_id = aws_security_group.security_group_front.id
  cidr_ipv4 = aws_subnet.private_2_sub.cidr_block
  from_port = 1935
  to_port = 1935
  ip_protocol = "tcp"
}


#Groupe de sécurité loadbalancer
resource "aws_security_group" "security_group_loadbalancer" {
  vpc_id = data.aws_vpc.vpc.id
  tags = {
    Name = var.security_group_name_loadbalancer
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_bastion_load" {
  security_group_id = aws_security_group.security_group_loadbalancer.id
  cidr_ipv4 = "${aws_network_interface.bastion_interface_public.private_ip}/32"
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.security_group_loadbalancer.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  ip_protocol = "tcp"
  to_port = 80
}
resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.security_group_loadbalancer.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 443
  ip_protocol = "tcp"
  to_port = 443
}


