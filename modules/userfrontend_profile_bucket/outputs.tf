

output "s3_bucket_arn" {
  value = aws_s3_bucket.frontend-web-bucket.arn
}



output "distribution_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "distribution_id" {
  value = aws_cloudfront_distribution.s3_distribution.id
}
