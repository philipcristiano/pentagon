
resource "aws_security_group" "master-elb-hillghost-kops-dev2-hillghost-com" {
  name = "master-elb.kops-dev2.hillghost.com"
  vpc_id = "${var.aws_vpc_id}"
  description = "Security group for master ELB"
  tags = {
    KubernetesCluster = "kops-dev2.hillghost.com"
    Name = "master-elb.kops-dev2.hillghost.com"
  }
}

resource "aws_security_group_rule" "all-public-to-master-elb" {
  type = "ingress"
  security_group_id = "${aws_security_group.master-elb-hillghost-kops-dev2-hillghost-com.id}"
  from_port = 443
  to_port = 443
  cidr_blocks = ["0.0.0.0/0"]
  protocol = "tcp"
}

resource "aws_security_group_rule" "master-elb-to-public" {
  type = "egress"
  security_group_id = "${aws_security_group.master-elb-hillghost-kops-dev2-hillghost-com.id}"
  from_port = 443
  to_port = 443
  cidr_blocks = ["0.0.0.0/0"]
  protocol = "tcp"
}

resource "aws_elb" "master-elb-hillghost-kops-dev2-hillghost-com" {
  name = "master-elb-kops-dev2"
  subnets = ["${var.vpc_public_az1_id}", "${var.vpc_public_az2_id}", "${var.vpc_public_az3_id}"  ]
  security_groups = ["${aws_security_group.master-elb-hillghost-kops-dev2-hillghost-com.id}"]
  listener {
    instance_port = 443
    instance_protocol = "tcp"
    lb_port = 443
    lb_protocol = "tcp"
  }

  tags {
    Name = "master-elb-hillghost-kops-dev2-hillghost-com"
  }
}


resource "aws_route53_record" "api-master" {
  zone_id = "${var.route53_name_zone_id}"
  name = "api.kops-dev2.hillghost.com"
  type = "A"

  alias {
    name = "${aws_elb.master-elb-hillghost-kops-dev2-hillghost-com.dns_name}"
    zone_id = "${aws_elb.master-elb-hillghost-kops-dev2-hillghost-com.zone_id}"
    evaluate_target_health = false
  }
}