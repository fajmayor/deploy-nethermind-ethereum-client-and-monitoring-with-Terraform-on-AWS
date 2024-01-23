/* # create security group for the ec2 instance connect endpoint
resource "aws_security_group" "eice_security_group" {
  name        = "eic-endpoint-sg"
  description = "enable outbound traffic on port 22 from the vpc cidr"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-eic-endpoint-sg"
  }
} */

# create security group for the app server
resource "aws_security_group" "app_server_security_group" {
  name        = "Webserver-sg"
  description = "enable http/https access on port 80/443 via alb sg and ssh via eice sg"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "http access"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    #security_groups = [aws_security_group.alb_security_group.id]
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    description     = "https access"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    #security_groups = [aws_security_group.alb_security_group.id]
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    description     = "ssh access"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    #security_groups = [aws_security_group.eice_security_group.id]
    cidr_blocks = [ "0.0.0.0/0" ]
  }

    ingress {
    description     = "grafana access"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    #security_groups = [aws_security_group.eice_security_group.id]
    cidr_blocks = [ "0.0.0.0/0" ]
  }

    ingress {
    description     = "prometheus access"
    from_port       = 9090
    to_port         = 9090
    protocol        = "tcp"
    #security_groups = [aws_security_group.eice_security_group.id]
    cidr_blocks = [ "0.0.0.0/0" ]
  }

    ingress {
    description     = "pushgateway access"
    from_port       = 9091
    to_port         = 9091
    protocol        = "tcp"
    #security_groups = [aws_security_group.eice_security_group.id]
    cidr_blocks = [ "0.0.0.0/0" ]
  }

    ingress {
    description     = "seq access"
    from_port       = 5341
    to_port         = 5341
    protocol        = "tcp"
    #security_groups = [aws_security_group.eice_security_group.id]
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-Webserver-Sg"
  }
}
