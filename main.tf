resource "aws_key_pair" "key" {
  key_name   = "pipeline"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}


resource "aws_instance" "kubernetes_node" {
  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"
  key_name               = "${aws_key_pair.key.id}"
  vpc_security_group_ids = ["${var.security_group_id}"]

  connection {
    user        = "centos"
    private_key = "${file("~/.ssh/id_rsa")}"
    host        = self.public_ip
  }

  tags = {
    Name = "kubernetes_node"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/provision_app_servers.sh"
    destination = "/var/tmp/provision_app_servers.sh"

  }

  provisioner "remote-exec" {
    inline = [
      "sudo bash /var/tmp/provision_app_servers.sh"
    ]
  }
}

resource "aws_instance" "kubernetes_master" {
  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"
  key_name               = "${aws_key_pair.key.id}"
  vpc_security_group_ids = ["${var.security_group_id}"]

  connection {
    user        = "centos"
    private_key = "${file("~/.ssh/id_rsa")}"
    host        = self.public_ip
  }

  tags = {
    Name = "kubernetes_master"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/provision_app_servers.sh"
    destination = "/var/tmp/provision_app_servers.sh"

  }

  provisioner "remote-exec" {
    inline = [
      "sudo bash /var/tmp/provision_app_servers.sh"
    ]
  }
}

output "public_ip_kubernetes_node" {
  value = "${aws_instance.kubernetes_node.public_ip}"
}

output "public_ip_kubernetes_master" {
  value = "${aws_instance.kubernetes_master.public_ip}"
}

