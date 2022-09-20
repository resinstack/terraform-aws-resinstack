output "api_addresses" {
  value = {
    nomad  = "http://${aws_lb.lb.dns_name}:4646"
    vault  = "http://${aws_lb.lb.dns_name}:8200"
    consul = "http://${aws_lb.lb.dns_name}:8500"
  }
  description = "API addresses of the running cluster"
}

resource "local_file" "bootstrap_vars" {
  filename = "${path.module}/cpolicy/vars.sh"
  content = templatefile("${path.module}/vars.sh.tpl",
    {
      alb_addr = aws_lb.lb.dns_name,
  })
}
