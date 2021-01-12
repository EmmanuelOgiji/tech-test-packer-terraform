# Output of dns name to access webserver via ELB
output "elb_dns_name" {
  value = aws_elb.my_elb.dns_name
}