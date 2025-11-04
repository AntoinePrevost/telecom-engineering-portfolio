#Créer clés bastion et instances

resource "tls_private_key" "key_bastion" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "tls_private_key" "key_instances" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#Enregistre les clés publiques dans AWS

resource "aws_key_pair" "public_key_bastion" {
  public_key = tls_private_key.key_bastion.public_key_openssh
  tags = {
    Name = var.key_name_bastion
  }
}
resource "aws_key_pair" "public_key_instances" {
  public_key = tls_private_key.key_instances.public_key_openssh
  tags = {
    Name = var.key_name_instances
  }
}

#Sauvegarder les clés privées localement

resource "local_file" "private_key_bastion" {
  filename = "${var.key_path}${var.key_name_bastion}.pem"
  content  = tls_private_key.key_bastion.private_key_pem
  file_permission = 0400
}
resource "local_file" "private_key_instances" {
  filename = "${var.key_path}${var.key_name_instances}.pem"
  content  = tls_private_key.key_instances.private_key_pem
  file_permission = 0400
}

