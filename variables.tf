variable "zone_name" {
    type = string
    default = "sivacloudlabs.online"
}
variable "vpn_sg_rules" {
  default = [
    {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "common_tags" {
  default = {
    Project = "expense"
    Environment = "dev"
    Terraform = "true"
  }
}