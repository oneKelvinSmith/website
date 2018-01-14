output "website_endpoint" {
  value = "${aws_s3_bucket.website.website_endpoint}"
}

output "name_servers" {
  value = "${aws_route53_zone.dns.name_servers}"
}
