resource "aws_security_group" "asg-web-sg" {
  name        = "asg-web-sg"
  description = "ASG Security Group"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description     = "HTTP ingress from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-web-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "alb-web-sg" {
  name        = "alb-web-sg"
  description = "ALB Security Group"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "HTTP ingress from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
