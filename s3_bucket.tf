resource "aws_s3_bucket" "image-bucket" {
    bucket  = "webserver-images-test"
    acl     = "public-read"
provisioner "local-exec" {
        command     = "git clone https://github.com/Tylke/image.git webserver-image"
    }
provisioner "local-exec" {
        when        =   destroy
        command     =   "echo Y | rmdir /s webserver-image"
    }
}
resource "aws_s3_bucket_object" "image-upload" {
    bucket  = aws_s3_bucket.image-bucket.bucket
    key     = "myphoto.jpeg"
    source  = "webserver-image/StudentPhoto.jpg"
    acl     = "public-read"
}