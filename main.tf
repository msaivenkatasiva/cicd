module "jenkins" {
    source = "terraform-aws-modules/ec2-instance/aws"
    create_security_group = false
    ami = data.aws_ami.ami_info.id
    name = "jenkins-tf"
    instance_type = "t3.small"
    vpc_security_group_ids = ["sg-0c6102baa1c21a48e"]
    subnet_id = "subnet-07a9062811586c3b4"
    user_data = file("jenkins.sh")
    tags = {
        Name = "jenkins-tf"
    }
}

module "jenkins_agent" {
    source = "terraform-aws-modules/ec2-instance/aws"
    create_security_group = false
    ami = data.aws_ami.ami_info.id
    name = "jenkins-agent"
    instance_type = "t3.small"
    vpc_security_group_ids = ["sg-0c6102baa1c21a48e"]
    subnet_id = "subnet-07a9062811586c3b4"
    user_data = file("jenkins-agent.sh")
    tags = {
        Name = "jenkins-agent"
    }
}

resource "aws_key_pair" "tools" {
  key_name   = "tools"
  # you can paste the public key directly like this
  #public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL6ONJth+DzeXbU3oGATxjVmoRjPepdl7sBuPzzQT2Nc sivak@BOOK-I6CR3LQ85Q"
  public_key = file("~/.ssh/tools.pub")
  # ~ means windows home directory
}

# module "nexus" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   create_security_group = false
#   name = "nexus"
#   instance_type          = "t3.medium"
#   vpc_security_group_ids = ["sg-0c6102baa1c21a48e"]
#   subnet_id = "subnet-07a9062811586c3b4"
#   ami = data.aws_ami.nexus_ami_info.id
#   key_name = aws_key_pair.tools.key_name
#   root_block_device = {
#       volume_type = "gp3"
#       volume_size = 30
#     }
  
#   tags = {
#     Name = "nexus"
#   }
# }

# module "sonar" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   create_security_group = false
#   name = "sonar"
#   instance_type          = "t3.medium"
#   vpc_security_group_ids = ["sg-0c6102baa1c21a48e"]
#   subnet_id = "subnet-07a9062811586c3b4"
#   ami = data.aws_ami.sonar_ami_info.id
#   key_name = aws_key_pair.tools.key_name
#   root_block_device = {
#       volume_type = "gp3"
#       volume_size = 30
#     }
  
#   tags = {
#     Name = "sonar"
#   }
# }



module "records" {
    source = "terraform-aws-modules/route53/aws//modules/records"
    version = "~> 2.0"
    zone_name = var.zone_name
    records = [
        {
            name = "jenkins"
            type = "A"
            ttl = 1
            records = [module.jenkins.public_ip]
            allow_overwrite = true           
        },
        {
            name = "jenkins-agent"
            type = "A"
            ttl = 1
            records = [module.jenkins_agent.private_ip]
            allow_overwrite = true
        },
        # {
        #     name = "nexus"
        #     type = "A"
        #     ttl = 1
        #     records = [module.nexus.private_ip]
        #     allow_overwrite = true
        # },
        # {
        #     name = "sonar"
        #     type = "A"
        #     ttl = 1
        #     records = [module.sonar.private_ip]
        #     allow_overwrite = true
        # }
    ]
}