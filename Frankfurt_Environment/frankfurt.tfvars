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
        source                      = ["10.10.0.0/16"] # Internal traffic
    },
    {
        type                        = "sg_rule",
        name                        = "frankfurt-sg-vpn",
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
        count                       = 1,
        ami                         = "ami-013f17f36f8b1fefb",
        private_ip                  = ["10.10.0.100"],
        instance_type               = "t2.micro",
        key_name                    = "terraform",
        monitoring                  = false,
        vpc_security_group_name     = ["frankfurt-sg-vpn"],
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
        name                        = "mongodb",
        ami                         = "ami-013f17f36f8b1fefb",
        count                       = 3,
        private_ip                  = ["10.10.0.200", "10.10.16.201", "10.10.32.202"],
        instance_type               = "t2.micro",
        key_name                    = "terraform",
        monitoring                  = false,
        vpc_security_group_name     = ["frankfurt-sg"],
        subnet_name                 = ["frankfurt-subnet-1", "frankfurt-subnet-2", "frankfurt-subnet-3"],
        environment                 = "frankfurt",
        associate_eip_address       = false,
        associate_public_ip_address = true,
        disable_api_termination     = false,
        ebs_optimized               = true,
        tags                        = {},
        root_block_device           = {
            volume_type = "gp2",
            volume_size = 8
        },
        ebs_block_device            = {
          device_name = "/dev/xvdf",
          volume_size = 8,
          volume_type = "gp2"
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
        tags                        = {"loadbalancer":"nginx"},
    },
        {
        type                        = "lb",
        category                    = "app",
        name                        = "app",
        security_group              = "frankfurt-sg",
        load_balancer_type          = "network",
        internal                    = true,
        idle_timeout                = 60,
        vpc_security_group_name     = ["frankfurt-sg"],
        subnet_names                = ["frankfurt-subnet-1", "frankfurt-subnet-2"],
        environment                 = "frankfurt",
        ports                       = {
            "protocol"  = "TCP",
            "port"      = 3000
        },
        tags                        = {"loadbalancer":"app"},
    },
    {
        type                        = "lc",
        category                    = "nginx",
        name                        = "nginx",
        ami                         = "ami-05a96e5affb1016c8",
        instance_type               = "t2.micro",
        key_name                    = "terraform",
        associate_public_ip_address = true,
        enable_monitoring           = true,
        security_group              = "frankfurt-sg",
        security_groups             = ["frankfurt-sg"],
        environment                 = "frankfurt",
    },
    {
        type                        = "lc",
        category                    = "app",
        name                        = "app",
        ami                         = "ami-072cd38ec12105ed1",
        instance_type               = "t2.micro",
        key_name                    = "terraform",
        associate_public_ip_address = true,
        enable_monitoring           = true,
        security_group              = "frankfurt-sg",
        security_groups             = ["frankfurt-sg"],
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
