# Load Balancer facing the application tier where users will connections to 
# in this project, it serves as the web entry point

resource "aws_lb" "web_lb" {
  name               = "web-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app_lb_sg.id]

  subnet_mapping {
    subnet_id = module.public_subnet_1.id
  }

  subnet_mapping {
    subnet_id = module.public_subnet_2.id
  }

}


# Load balancing target group

resource "aws_lb_target_group" "lb_tg" {
  name        = "lb-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc-lamp.id

  stickiness {
    enabled = false
    type    = "app_cookie"
  }
}

# Load balancer Target Group attachment to insctances

resource "aws_lb_target_group_attachment" "tg_att_1" {
  target_group_arn = aws_lb_target_group.lb_tg.arn
  target_id        = module.app_server_01.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "tg_att_2" {
  target_group_arn = aws_lb_target_group.lb_tg.arn
  target_id        = module.app_server_02.id
  port             = 80
}

#Load Balancer Listener to target group

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg.arn
  }

}