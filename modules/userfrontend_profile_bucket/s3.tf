



resource "aws_s3_bucket" "frontend-web-bucket" {
  bucket = "thuthuhan-frontend-bucket"

  tags = {
    Name        = "frontend-web-bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.frontend-web-bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [aws_s3_bucket_ownership_controls.example]

  bucket = aws_s3_bucket.frontend-web-bucket.id
  acl    = "private"
}



resource "aws_s3_object" "object" {
  bucket   = aws_s3_bucket.frontend-web-bucket.id
  for_each = fileset("dist", "**")

  key    = each.value
  source = "dist/${each.value}"
  etag   = filemd5("dist/${each.value}")

  content_type = lookup(
    {
      "html" = "text/html",
      "css"  = "text/css",
      "js"   = "application/javascript",
      "json" = "application/json",
      "svg"  = "image/svg+xml",
      "png"  = "image/png",
      "jpg"  = "image/jpeg"
    },
    regex("^.*\\.([^.]+)$", each.value)[0],
    "application/octet-stream"
  )
}



