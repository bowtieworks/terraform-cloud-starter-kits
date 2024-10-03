data "aws_eip" "eip_data" {
  count     = length(var.eip_addresses)
  public_ip = var.eip_addresses[count.index]
}

data "aws_ami" "controller" {
  most_recent = true
  owners      = var.owner_id
}

resource "aws_instance" "instance" {
  count                       = length(var.controller_name)
  ami                         = data.aws_ami.controller.id
  iam_instance_profile        = var.iam_instance_profile
  instance_type               = var.instance_type
  subnet_id                   = length(var.subnet_ids) > count.index ? var.subnet_ids[count.index] : var.subnet_ids[0]
  vpc_security_group_ids      = var.vpc_security_group_ids

  user_data = var.join_existing_cluster ? file("${path.module}/${var.cloud_init_join_cluster}") : (
    count.index == 0 ? file("${path.module}/${var.cloud_init_first_instance}") : file("${path.module}/${var.cloud_init_join_cluster}")
  )

  tags = {
    Name = "${var.controller_name[count.index]}-instance"
  }
}

resource "aws_eip_association" "eip_assoc" {
  count         = length(var.controller_name)
  instance_id   = aws_instance.instance[count.index].id
  allocation_id = data.aws_eip.eip_data[count.index].id

  depends_on = [aws_instance.instance]
}