resource "aws_launch_template" "launch-template-web" {
  name          = "launch-template-web"
  image_id      = var.image_id
  instance_type = var.ec2_instance_type

  network_interfaces {
    security_groups = [aws_security_group.asg-web-sg.id]
    associate_public_ip_address = true # Required for web VMs in public subnet to access internet via IGW
  }

  user_data = base64encode(<<-EOF
                #!/bin/bash
                yum update -y
                yum install httpd -y
                systemctl start httpd
                systemctl enable httpd
                TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
                curl http://169.254.169.254/latest/meta-data/instance-id -H "X-aws-ec2-metadata-token: $TOKEN" >> info.txt
                echo "<br />" >> info.txt
                curl http://169.254.169.254/latest/meta-data/local-ipv4 -H "X-aws-ec2-metadata-token: $TOKEN" >> info.txt
                echo "<html>" $(cat info.txt) "</html>" > /var/www/html/index.html
                EOF
  )     

}

resource "aws_lb" "alb-web" {
  name               = "alb-web"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-web-sg.id]
  subnets            = [for i in range(var.subnet_depth) : aws_subnet.web_subnets[i].id]
}

resource "aws_lb_target_group" "tg-web" {
  name     = "tg-web"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = "60"
    port                = "80"
  }
}

resource "aws_lb_listener" "alb-listener-web" {
  load_balancer_arn = aws_lb.alb-web.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-web.arn
  }
}

resource "aws_autoscaling_group" "asg-web" {
  name                = "asg-web"
  desired_capacity    = 2
  max_size            = 2
  min_size            = 2
  target_group_arns   = [aws_lb_target_group.tg-web.arn]
  health_check_type   = "ELB"
  vpc_zone_identifier = [for i in range(var.subnet_depth) : aws_subnet.web_subnets[i].id]

  launch_template {
    id      = aws_launch_template.launch-template-web.id
    version = aws_launch_template.launch-template-web.latest_version
  }

}
