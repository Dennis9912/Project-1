#Configure Simple routing policy
resource "aws_route53_record" "dns_record" {
  zone_id = var.zone_id     # You must get this from the AWS console in Route 53
  name    = var.dns_name  # Name of your registered domain name in route 53
  type    = "A"
  
  alias {
    name           = var.alb_dns_name   # the dns name for ALB
    zone_id        = var.alb_zone_id    # the zone id for ALB
    evaluate_target_health = true
 }
}