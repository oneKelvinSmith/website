terraform {
  required_version = "~> 0.11.2"
}

provider "aws" {
  region = "${var.region}"
}


# ACM SSL Certification

data "aws_acm_certificate" "ssl" {
  domain   = "${var.domain}"
  statuses = ["ISSUED"]
}


# S3 Static Site

data "aws_iam_policy_document" "website" {
  statement {
    sid = "PublicReadGetObject"

    actions = ["s3:GetObject"]

    principals = {
      type        = "*"
      identifiers = ["*"]
    }

   resources = ["arn:aws:s3:::${var.domain}/*"]
  }
}

resource "aws_s3_bucket" "website" {
  bucket = "${var.domain}"
  acl    = "public-read"
  policy = "${data.aws_iam_policy_document.website.json}"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  force_destroy = true
}

resource "aws_s3_bucket_object" "index" {
  acl          = "public-read"
  bucket       = "${aws_s3_bucket.website.id}"
  content_type = "text/html"
  etag         = "${md5(file("../static/index.html"))}"
  key          = "index.html"
  source       = "../static/index.html"
}

resource "aws_s3_bucket_object" "error" {
  acl          = "public-read"
  bucket       = "${aws_s3_bucket.website.id}"
  content_type = "text/html"
  etag         = "${md5(file("../static/error.html"))}"
  key          = "error.html"
  source       = "../static/error.html"
}


# Cloudfront

resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = "${aws_s3_bucket.website.bucket_domain_name}"
    origin_id   = "${var.domain}"
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Welcome"
  default_root_object = "index.html"

  aliases = ["${var.domain}"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.domain}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn = "${data.aws_acm_certificate.ssl.arn}"
    ssl_support_method  = "sni-only"
  }
}


# Route53

resource "aws_route53_zone" "dns" {
  name = "${var.domain}"
}

resource "aws_route53_record" "domain" {
  zone_id = "${aws_route53_zone.dns.zone_id}"
  name    = "${var.domain}"
  type    = "A"

  alias {
    name    = "${aws_cloudfront_distribution.cdn.domain_name}"
    zone_id = "${aws_cloudfront_distribution.cdn.hosted_zone_id}"

    evaluate_target_health = true
  }
}
