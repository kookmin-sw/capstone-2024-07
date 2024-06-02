resource "aws_alb" "staging" {
  name               = "alb-${var.env_suffix}"
  subnets            = aws_subnet.public.*.id
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  internal           = false

  access_logs {
    bucket  = aws_s3_bucket.log_storage.id
    prefix  = "frontend-alb"
    enabled = true
  }

  tags = {
    Environment = "staging"
    Application = var.app_name
  }
}

resource "aws_lb_listener" "https_forward" {
  load_balancer_arn = aws_alb.staging.id
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.cert.arn
  ssl_policy        = "ELBSecurityPolicy-2016-08"

#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.staging.id
#  }
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener_rule" "api" {
  listener_arn = aws_lb_listener.https_forward.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.staging.id
  }

  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}

resource "aws_lb_listener_rule" "temp" {
  listener_arn = aws_lb_listener.https_forward.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.staging.id
  }

  condition {
    path_pattern {
      values = ["/predict/"]
    }
  }
}

resource "aws_lb_listener" "http_forward" {
  load_balancer_arn = aws_alb.staging.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_target_group" "staging" {
  vpc_id                = aws_vpc.cluster_vpc.id
  name                  = "service-alb-tg-${var.env_suffix}"
  port                  = var.host_port
  protocol              = "HTTP"
  target_type           = "ip"
  deregistration_delay  = 30

  health_check {
    interval            = 120
    path                = "/api/health-check"
    timeout             = 60
    matcher             = "200"
    healthy_threshold   = 5
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}