data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

resource "aws_instance" "ubuntu_instances" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = data.aws_subnets.selected.ids[count.index % length(data.aws_subnets.selected.ids)]
  vpc_security_group_ids = [var.security_group_id]

  user_data = <<-EOF
              #!/bin/bash
              set -euxo pipefail

              export DEBIAN_FRONTEND=noninteractive

              # Update packages
              apt-get update -y

              # Install Docker
              curl -fsSL https://get.docker.com | bash
              chmod 777 /var/run/docker.sock

              # Install rclone, cron, fuse3, tzdata
              apt-get install -y --no-install-recommends rclone cron fuse3 tzdata ca-certificates

              # Set timezone to Asia/Kolkata (IST)
              timedatectl set-timezone Asia/Kolkata || true

              # Allow FUSE mounts to be accessible by other users (useful for rclone)
              grep -q '^user_allow_other' /etc/fuse.conf || echo 'user_allow_other' >> /etc/fuse.conf

              # Enable and start cron
              systemctl enable cron
              systemctl restart cron

              # (Optional) sanity check: log cron is running
              echo "* * * * * echo \$(date) >> /var/log/cron-ok.log 2>&1" | crontab -u root -

              # Placeholders for future scripts
              mkdir -p /opt/scripts
              chmod -R 755 /opt/scripts

              EOF

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "Ubuntu-Instance-${count.index + 1}"
  }
}
