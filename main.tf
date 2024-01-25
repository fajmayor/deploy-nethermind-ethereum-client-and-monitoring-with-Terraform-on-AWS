resource "tls_private_key" "nethermind_pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "nethermind_kp" {
  key_name   = "key-pair-nethermind"       # Create a "myKey" to AWS!!
  public_key = tls_private_key.nethermind_pk.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.nethermind_kp.key_name}.pem"
  content =  tls_private_key.nethermind_pk.private_key_pem
  file_permission = "400"
}

resource "aws_instance" "nethermind-server" {
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
    private_key = file("${local_file.ssh_key.filename}")
    timeout     = "3m"
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
      "sudo docker-compose up -d"
    ]
  }
}