output "lb_pub_ip" {
    value = module.alb.lb_public_ip
    description = "Public facing load balancer IP"
}