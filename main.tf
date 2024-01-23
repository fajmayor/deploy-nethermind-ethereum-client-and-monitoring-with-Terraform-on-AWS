resource "aws_instance" "data_migrate_ec2" {
  ami                    = var.ami_id
  instance_type          = var.ec2_instance_type
  subnet_id              = aws_subnet.public_subnet_az1.id
  vpc_security_group_ids = [aws_security_group.app_server_security_group.id]
  associate_public_ip_address = true

  key_name = "key-pair-nethermind"

  tags = {
    Name = "${var.project_name}-${var.environment}-ec2"
  }


  provisioner "file" {
    source      = "./docker-compose.yml"
    destination = "/home/ubuntu/docker-compose.yaml"
  }

  provisioner "file" {
    source      = "./NLog.config"
    destination = "/home/ubuntu/NLog.config"

  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./key-pair-nethermind.pem")
    timeout     = "5m"
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y docker docker-compose",
      "git clone https://github.com/NethermindEth/metrics-infrastructure.git",
      "cp -r metrics-infrastructure/grafana metrics-infrastructure/prometheus .",
      "export HOST=$(curl ifconfig.me)",
      "export NAME=\"Nethermind node on ${var.config}\"",
      "sed -i '10s/.*/            - NETHERMIND_CONFIG=${var.config}/' docker-compose.yaml",
      "sed -i '30s/.*/            - NETHERMIND_JSONRPCCONFIG_ENABLED=${var.rpc_enabled}/' docker-compose.yaml",
      "sed -i '36s/.*/            <target xsi:type=\"Seq\" serverUrl=\"'\"http:\\/\\/$HOST:5341\"'\" apiKey=\"Test\">/' NLog.config",
      "sudo docker-compose up -d --build"
    ]
  }
}