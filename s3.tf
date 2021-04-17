resource "aws_s3_bucket" "mlem-mlem" {
  bucket = "mlem-mlem-revision"
  acl    = "private"

  tags = {
    Name = "mlem revision"
  }
}
