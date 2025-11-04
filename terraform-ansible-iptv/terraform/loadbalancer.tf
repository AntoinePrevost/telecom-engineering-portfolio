#Créer les instances front
resource "aws_instance" "loadbalancer" {
  ami =                         var.instance_ami_loadbalancer
  instance_type =               var.instance_type_loadbalancer
  subnet_id =                   aws_subnet.public_sub.id
  vpc_security_group_ids =      [aws_security_group.security_group_all_egress.id,aws_security_group.security_group_loadbalancer.id]
  key_name =                    aws_key_pair.public_key_instances.key_name
  associate_public_ip_address = true
  source_dest_check =           true
  tags = {
    Name = var.instance_loadbalancer_name
  }
}

output "ip_loadbalancer" {
  value = "${aws_instance.loadbalancer.private_ip}"
  description = "Adresse IP private loadbalancer-EC2 instance"
}