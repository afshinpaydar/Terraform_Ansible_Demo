aws_profile = "afshingolang-production"
aws_region  = "us-east-1"
objects = [
    {
        type                        = "sg_rule",
        name                        = "frankfurt-sg-office-access",
        vpc_name                    = "frankfurt-vpc",
        from_port                   = 0,
        to_port                     = 0,
        protocol                    = "-1",
        source                      = ["211.24.127.133/32"] # Office Access
    },
    {
        type                        = "sg_rule",
        name                        = "frankfurt-sg-ssh-access",
        vpc_name                    = "frankfurt-vpc",
        from_port                   = 22,
        to_port                     = 22,
        protocol                    = "tcp",
        source                      = ["0.0.0.0/0"]
    },
    {
        type                        = "sg_rule",
        name                        = "frankfurt-sg-http-access",
        vpc_name                    = "frankfurt-vpc",
        from_port                   = 80,
        to_port                     = 80,
        protocol                    = "tcp",
        source                      = ["0.0.0.0/0"]
    },
    {
        type                        = "sg_rule",
        name                        = "frankfurt-sg-https-access",
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
        private_ip                  = ["172.31.21.100", "172.31.21.101", "172.31.21.102"],
        instance_type               = "t2.micro",
        key_name                    = "afshingolang-production",
        vpc_security_group_name     = ["frankfurt-sg"],
        subnet_name                 = "frankfurt-subnet-1",
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
        db                          = true,
        count                       = 1,
        ami                         = "ami-013f17f36f8b1fefb",
        private_ip                  = ["172.31.21.200", "172.31.21.201", "172.31.21.202"],
        instance_type               = "t2.micro",
        key_name                    = "afshingolang-production",
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
            volume_size = 20
        }
    },
    {
        type                        = "lb",
        category                    = "nginx",
        name                        = "nginx",
        ports                        = {"HTTP": 80},
        create_elb                  = true,
        count                       = 0,
        security_groups             = [],
        load_balancer_type          = "application",
        internal                    = false,
        idle_timeout                = 60,
        vpc_security_group_name     = ["frankfurt-sg"],
        subnet_names                = ["frankfurt-subnet-1", "frankfurt-subnet-2"],
        environment                 = "frankfurt",
        tags                        = {},
    },
        {
        type                        = "lb",
        category                    = "app",
        name                        = "app",
        ports                       = {"HTTP": 80},
        create_elb                  = true,
        count                       = 0,
        security_groups             = [],
        load_balancer_type          = "application",
        internal                    = true,
        idle_timeout                = 60,
        vpc_security_group_name     = ["frankfurt-sg"],
        subnet_names                = ["frankfurt-subnet-1", "frankfurt-subnet-2"],
        environment                 = "frankfurt",
        tags                        = {},
    },
]