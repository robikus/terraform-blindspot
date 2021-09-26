# I needed to create 2 buckets - DEV and PROD.
resource "aws_s3_bucket" "target_bucket" {
  count  = length(var.enviroments)
  bucket = "my-taget-bucket-${var.enviroments[count.index]}"
  acl    = "public-read"
  versioning {
    enabled = false
  }
  tags = {
    Environment = "${var.enviroments[count.index]}"
  }
  website {
    index_document = "index.html"
  }
}
