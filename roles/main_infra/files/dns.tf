# Internal DNS Zone
resource "aws_route53_zone" "main" {
  name   = "${var.prefix}.${var.dns_zone_name}"
  vpc {
    vpc_id = "${aws_vpc.vpc.id}"
  }

  tags {
    prefix = "${var.prefix}"
    origin = "terraform"
  }
}

# Private DNS records
resource "aws_route53_record" "db" {
  zone_id = "${aws_route53_zone.main.zone_id}"
  name    = "db${count.index}"
  type    = "A"
  count   = "${length(var.chains)}"

  alias {
    name                   = "${aws_db_instance.default.*.address[count.index]}"
    zone_id                = "${aws_db_instance.default.*.hosted_zone_id[count.index]}"
    evaluate_target_health = false
  }
}
