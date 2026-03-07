



resource "aws_cloudfront_distribution" "nextjs_cloudfront" {

  enabled             = true
  comment             = "nextjs-cloudfront"
  is_ipv6_enabled     = true
  default_root_object = ""

  origin {
    domain_name = aws_instance.nextjs_app.public_dns
    origin_id   = "nextjs-ec2-origin"

    custom_origin_config {
      http_port              = 3160
      https_port             = 443
      origin_protocol_policy = "http-only"

      origin_ssl_protocols = [
        "TLSv1.2"
      ]
    }
  }

  default_cache_behavior {

    target_origin_id = "nextjs-ec2-origin"

    viewer_protocol_policy = "allow-all"

    allowed_methods = [
      "GET",
      "HEAD",
      "OPTIONS",
      "PUT",
      "POST",
      "PATCH",
      "DELETE"
    ]

    cached_methods = [
      "GET",
      "HEAD"
    ]

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  price_class = "PriceClass_100"

}


