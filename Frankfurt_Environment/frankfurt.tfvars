aws_profile = "afshingolang-production"


aws_region  = "us-east-1"
objects = [
    {
        type                        = "sg_rule",
        name                        = "frankfurt-sg",
        vpc_name                    = "frankfurt-vpc",
        from_port                   = 0,
        to_port                     = 0,
        protocol                    = "-1",
        source                      = ["211.24.127.133/32"] # Office Access
    },
    {
        type                        = "sg_rule",
        name                        = "frankfurt-sg",
        vpc_name                    = "frankfurt-vpc",
        from_port                   = 0,
        to_port                     = 0,
        protocol                    = "-1",
        source                      = ["10.10.0.0/16"] # Internal traffic
    },
    {
        type                        = "sg_rule",
        name                        = "frankfurt-sg",
        vpc_name                    = "frankfurt-vpc",
        from_port                   = 22,
        to_port                     = 22,
        protocol                    = "tcp",
        source                      = ["0.0.0.0/0"]
    },
    {
        type                        = "sg_rule",
        name                        = "frankfurt-sg-lb",
        vpc_name                    = "frankfurt-vpc",
        from_port                   = 80,
        to_port                     = 80,
        protocol                    = "tcp",
        source                      = ["0.0.0.0/0"]
    },
    {
        type                        = "sg_rule",
        name                        = "frankfurt-sg-lb",
        vpc_name                    = "frankfurt-vpc",
        from_port                   = 443,
        to_port                     = 443,
        protocol                    = "tcp",
        source                      = ["0.0.0.0/0"]
    },
    {
        type                        = "ec2",
        category                    = "vpn",
        db                          = false
        count                       = 1,
        ami                         = "ami-013f17f36f8b1fefb",
        private_ip                  = ["10.10.0.100", "10.10.0.101", "10.10.0.102"],
        instance_type               = "t2.micro",
        key_name                    = "afshingolang-production",
        monitoring                  = false,
        vpc_security_group_name     = ["frankfurt-sg"],
        subnet_name                 = "frankfurt-subnet-1",
        environment                 = "frankfurt",
        associate_eip_address       = false,
        associate_public_ip_address = true,
        disable_api_termination     = false,
        ebs_optimized               = true,
        tags                        = {},
        root_block_device           = {
            volume_type = "gp2",
            volume_size = 8
        }
    },
    {
        type                        = "db",
        name                        = "mongodb01",
        ami                         = "ami-013f17f36f8b1fefb",
        count                       = 1,
        private_ip                  = "10.10.0.200",
        instance_type               = "t2.micro",
        key_name                    = "afshingolang-production",
        monitoring                  = false,
        vpc_security_group_name     = ["frankfurt-sg"],
        subnet_name                 = "frankfurt-subnet-1",
        environment                 = "frankfurt",
        associate_eip_address       = false,
        associate_public_ip_address = false,
        disable_api_termination     = false,
        ebs_optimized               = true,
        tags                        = {},
        root_block_device           = {
            volume_type = "gp2",
            volume_size = 8
        }
    },
        {
        type                        = "db",
        name                        = "mongodb02",
        ami                         = "ami-013f17f36f8b1fefb",
        count                       = 1,
        private_ip                  = "10.10.16.201",
        instance_type               = "t2.micro",
        key_name                    = "afshingolang-production",
        monitoring                  = false,
        vpc_security_group_name     = ["frankfurt-sg"],
        subnet_name                 = "frankfurt-subnet-2",
        environment                 = "frankfurt",
        associate_eip_address       = false,
        associate_public_ip_address = false,
        disable_api_termination     = false,
        ebs_optimized               = true,
        tags                        = {},
        root_block_device           = {
            volume_type = "gp2",
            volume_size = 8
        }
    },
        {
        type                        = "db",
        name                        = "mongodb03",
        ami                         = "ami-013f17f36f8b1fefb",
        count                       = 1,
        private_ip                  = "10.10.32.202",
        instance_type               = "t2.micro",
        key_name                    = "afshingolang-production",
        monitoring                  = false,
        vpc_security_group_name     = ["frankfurt-sg"],
        subnet_name                 = "frankfurt-subnet-3",
        environment                 = "frankfurt",
        associate_eip_address       = false,
        associate_public_ip_address = false,
        disable_api_termination     = false,
        ebs_optimized               = true,
        tags                        = {},
        root_block_device           = {
            volume_type = "gp2",
            volume_size = 8
        }
    },
    {
        type                        = "lb",
        category                    = "nginx",
        name                        = "nginx",
        security_group              = "frankfurt-sg-lb",
        load_balancer_type          = "application",
        internal                    = false,
        idle_timeout                = 60,
        vpc_security_group_name     = ["frankfurt-sg-lb"],
        subnet_names                = ["frankfurt-subnet-1", "frankfurt-subnet-2"],
        environment                 = "frankfurt",
        ports                       = {
            "protocol"  = "HTTP",
            "port"      = 80
        },
        tags                        = {},
    },
        {
        type                        = "lb",
        category                    = "app",
        name                        = "app",
        security_group             = "frankfurt-sg",
        load_balancer_type          = "network",
        internal                    = true,
        idle_timeout                = 60,
        vpc_security_group_name     = ["frankfurt-sg"],
        subnet_names                = ["frankfurt-subnet-1", "frankfurt-subnet-2"],
        environment                 = "frankfurt",
        ports                       = {
            "protocol"  = "TCP",
            "port"      = 80
        },
        tags                        = {},
    },
    {
        type                        = "lc",
        category                    = "nginx",
        name                        = "nginx",
        ami                         = "ami-013f17f36f8b1fefb",
        instance_type               = "t2.micro",
        key_name                    = "afshingolang-production",
        associate_public_ip_address = true,
        enable_monitoring           = true,
        security_groups             = ["sg-010be917f86891b38"],
        environment                 = "frankfurt"
    },
    {
        type                        = "lc",
        category                    = "app",
        name                        = "app",
        ami                         = "ami-013f17f36f8b1fefb",
        instance_type               = "t2.micro",
        key_name                    = "afshingolang-production",
        associate_public_ip_address = true,
        enable_monitoring           = true,
        security_groups             = ["sg-010be917f86891b38"],
        environment                 = "frankfurt"
    },
    {
        type                        = "asg",
        category                    = "nginx",
        name                        = "nginx",
        vpc_zone_identifier         = ["subnet-0a5157ab3f678608e", "subnet-0ac1eb29027382b06", "subnet-0df75ca162aa2be7a"],
        min_size                    = 1,
        max_size                    = 1,
        timeout_delete              = "10m"
        environment                 = "frankfurt"
    },
    {
        type                        = "asg",
        category                    = "app",
        name                        = "app",
        vpc_zone_identifier         = ["subnet-0a5157ab3f678608e", "subnet-0ac1eb29027382b06", "subnet-0df75ca162aa2be7a"],
        min_size                    = 2,
        max_size                    = 3,
        timeout_delete              = "10m"
        environment                 = "frankfurt"
    },
]
