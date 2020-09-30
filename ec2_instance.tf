resource "aws_instance" "webserver" {
    ami                     = "ami-01fee56b22f308154"
    instance_type           = "t2.micro"
    key_name                = aws_key_pair.webserver_key.key_name
    vpc_security_group_ids  = [aws_security_group.webserver_sg.id]
    subnet_id               = "subnet-9aeb62d6"
    availability_zone       = "us-west-2"
    root_block_device {
        volume_type     = "gp2"
        volume_size     = 12
        delete_on_termination   = true
    }
tags = {
        Name = "webserver"
    }
connection {
        type    = "ssh"
        user    = "ec2-user"
        host    = aws_instance.webserver.public_ip
        port    = 22
        private_key = tls_private_key.webserver_key.private_key_pem
    }
provisioner "remote-exec" {
        inline = [
        "sudo yum install httpd -y",
        "sudo systemctl start httpd",
        "sudo systemctl enable httpd",
        "sudo yum install git -y"
        ]
    }
}