resource "cloudflare_record" "pritunl-dev" {
  zone_id = var.cloudflare_zone_id
  name    = var.pritunl_record_name
  value   = var.ip_address
  type    = "A"
  ttl     = 60
  allow_overwrite = true
  proxied = false
}
