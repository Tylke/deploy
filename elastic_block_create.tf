resource "aws_ebs_volume" "document_root" {
    availability_zone = aws_instance.webserver.availability_zone
    size              = 1
    type = "gp2"
    tags = {
        Name = "document_root"
    }
}
resource "aws_volume_attachment" "document_root_mount" {
    device_name = "/dev/xvdb"
    volume_id   = aws_ebs_volume.document_root.id
    instance_id = aws_instance.webserver.id
connection {
        type    = "ssh"
        user    = "ec2-user"
        host    = aws_instance.webserver.public_ip
        port    = 22
        private_key = tls_private_key.webserver_key.private_key_pem
    }
provisioner "remote-exec" {
        inline  = [
            "sudo mkfs.ext4 /dev/xvdb",
            "sudo mount /dev/xvdb /var/www/html",
            "sudo git clone git@github.com:Tylke/deploy.git /temp_repo",
            "sudo cp -rf /temp_repo/* /var/www/html",
            "sudo rm -rf /temp_repo",
            "sudo setenforce 0"
        ]
    }
    provisioner "remote-exec" {
        when    = destroy
        inline  = [
            "sudo umount /var/www/html"
        ]
    }
}