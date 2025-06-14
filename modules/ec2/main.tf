resource "aws_instance" "web" {
  ami           = var.ami
  instance_type = "t3.micro"
  subnet_id = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  associate_public_ip_address = true

  tags = {
    Name = "public web serverr"
  }
}