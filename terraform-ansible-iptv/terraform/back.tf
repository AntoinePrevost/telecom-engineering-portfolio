#Créer le nombre d'instance EC2 back-end que l'on veut
resource "aws_instance" "machines_back" {
  count                       = var.nombre_instance_back
  ami                         = var.instance_ami_back
  instance_type               = var.instance_type_back
  subnet_id                   = aws_subnet.private_2_sub.id
  vpc_security_group_ids      = [aws_security_group.security_group_all_egress.id,aws_security_group.security_group_back.id]
  key_name                    = aws_key_pair.public_key_instances.key_name
  associate_public_ip_address = false
  source_dest_check           = true
  tags = {
    Name = "${var.instance_back_name}-${count.index}"
  }
}

output "ip_back" {
  description = "All back-EC2 instances private IP :"
  value = join("\n", [
    for instance in aws_instance.machines_back :
    "${instance.tags["Name"]} : ${instance.private_ip}"
  ])
}
