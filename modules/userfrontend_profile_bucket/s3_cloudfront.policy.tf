
resource "aws_s3_bucket_policy" "cloudfront_policy" {
  bucket = aws_s3_bucket.frontend-web-bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "PolicyForCloudFrontOACRead"
    Statement = [{
      Sid    = "AllowCloudFrontOACRead"
      Effect = "Allow"
      Principal = {
        Service = "cloudfront.amazonaws.com"
      }
      Action = "s3:GetObject"
      Resource = "${aws_s3_bucket.frontend-web-bucket.arn}/*" # Correct interpolation and dynamic ARN
      Condition = {
        StringEquals = {
          "AWS:SourceArn" = aws_cloudfront_distribution.s3_distribution.arn # Correct interpolation
        }
      }
    }]
  })
}
