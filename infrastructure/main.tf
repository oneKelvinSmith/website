terraform {
  required_version = "~> 0.11.2"
}

provider "aws" {
  region = "eu-west-1"
}

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
