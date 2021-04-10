aws_profile = "afshingolang-production"
aws_region  = "us-east-1"
objects = [
    {
        type                        = "sg_rule",
        name                        = "sg_terraform",
        vpc_name                    = "default",
        from_port                   = 0,
        to_port                     = 0,
        protocol                    = "-1",
        source                      = ["211.24.127.133/32"]
    },
    {
        type                        = "sg_rule",
        name                        = "sg_terraform",
        vpc_name                    = "default",
        from_port                   = 22,
        to_port                     = 22,
        protocol                    = "tcp",
        source                      = ["47.254.179.3/32", "211.24.127.133/32"]
    },
    {
        type                        = "ec2",
        category                    = "vpn",
        count                       = 1,
        ami                         = "ami-013f17f36f8b1fefb",
        private_ip                  = ["172.31.21.100", "172.31.21.101", "172.31.21.102"],
        instance_type               = "t2.micro",
        key_name                    = "afshingolang-production",
        vpc_security_group_name     = ["sg_terraform"],
        subnet_name                 = "default_2",
        environment                 = "frankfurt",
        associate_eip_address       = true,
        associate_public_ip_address = false,
        disable_api_termination     = false,
        ebs_optimized               = true,
        tags                        = {},
        root_block_device           = {
            volume_type = "gp2",
            volume_size = 20
        }
    },
    {
        type                        = "ec2",
        category                    = "db",
        count                       = 3,
        ami                         = "ami-013f17f36f8b1fefb",
        private_ip                  = ["172.31.21.200", "172.31.21.201", "172.31.21.202"],
        instance_type               = "t2.micro",
        key_name                    = "afshingolang-production",
        vpc_security_group_name     = ["sg_terraform"],
        subnet_name                 = "default_2",
        environment                 = "frankfurt",
        associate_eip_address       = false,
        associate_public_ip_address = false,
        disable_api_termination     = false,
        ebs_optimized               = true,
        tags                        = {},
        root_block_device           = {
            volume_type = "gp2",
            volume_size = 20
        }
    },
    {
        type                        = "lb",
        category                    = "nginx",
        name                        = "nginx-lb",
        create_elb                  = true,
        count                       = 1,
        security_groups             = [],
        load_balancer_type          = "application",
        subnets                     = ["subnet-090604d28c170ae0f", "subnet-0f6353d798bf5d5fa"],
        internal                    = false,
        idle_timeout                = 60,
        vpc_security_group_name     = ["sg_terraform"],
        subnet_name                 = "default_2",
        environment                 = "frankfurt",
        tags                        = {},
    },
        {
        type                        = "lb",
        category                    = "app",
        name                        = "app-lb",
        create_elb                  = true,
        count                       = 1,
        security_groups             = [],
        load_balancer_type          = "application",
        subnets                     = ["subnet-090604d28c170ae0f", "subnet-0f6353d798bf5d5fa"],
        internal                    = true,
        idle_timeout                = 60,
        vpc_security_group_name     = ["sg_terraform"],
        subnet_name                 = "default_2",
        environment                 = "frankfurt",
        tags                        = {},
    },
]
