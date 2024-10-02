resource "aws_vpc" "vpc" {
  count      = var.create_vpc ? 1 : 0
  cidr_block = var.cidr_block

  tags = {
    Name = var.vpc_name
  }
}

data "aws_vpc" "existing_vpc" {
  count = var.create_vpc ? 0 : (var.vpc_id != "" ? 1 : 0)
  id    = var.vpc_id
}

resource "aws_subnet" "subnets" {
  count             = var.create_subnets ? length(var.subnet_names) : 0
  vpc_id            = var.create_vpc ? aws_vpc.vpc[0].id : data.aws_vpc.existing_vpc[0].id
  cidr_block        = var.subnet_cidrs[count.index]
  availability_zone = var.subnet_azs[count.index]

  tags = {
    Name = var.subnet_names[count.index]
  }
}

data "aws_subnet" "existing_subnet" {
  count = var.subnet_id != "" ? 1 : 0
  id    = var.subnet_id
}

data "aws_subnet" "default_subnets" {
  count = (!var.create_subnets && var.subnet_id == "") ? 1 : 0

  filter {
    name   = "default-for-az"
    values = ["true"]
  }

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_internet_gateway" "existing_igw" {
  count = var.create_vpc ? 0 : 1

  filter {
    name   = "attachment.vpc-id"
    values = [var.vpc_id]
  }
}

resource "aws_internet_gateway" "igw" {
  count  = var.create_vpc ? 1 : 0
  vpc_id = aws_vpc.vpc[0].id

  tags = {
    Name = "bowtie-igw"
  }
}

data "aws_route_table" "existing_rt" {
  count = var.create_vpc ? 0 : 1

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  filter {
    name   = "association.main"
    values = ["true"]
  }
}

resource "aws_route_table" "rt" {
  count  = var.create_vpc ? 1 : 0
  vpc_id = aws_vpc.vpc[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }

  tags = {
    Name = "bowtie-rt"
  }
}

resource "aws_route_table_association" "subnet_rt_assoc" {
  count = var.create_subnets ? length(var.subnet_names) : 0

  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.rt[0].id
}