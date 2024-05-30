resource "aws_vpc" "vpc" {
  count      = var.create_vpc ? 1 : 0
  cidr_block = var.cidr_block

  tags = {
    Name = var.vpc_name
  }
}

data "aws_vpc" "vpc_data" {
  count = var.create_vpc ? 0 : 1

  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

resource "aws_subnet" "subnets" {
  count             = var.create_subnets ? length(var.subnet_names) : 0
  vpc_id            = var.create_vpc ? aws_vpc.vpc[0].id : data.aws_vpc.vpc_data[0].id
  cidr_block        = var.subnet_cidrs[count.index]
  availability_zone = var.subnet_azs[count.index]

  tags = {
    Name = var.subnet_names[count.index]
  }
}

data "aws_subnet" "subnets_data" {
  count = !var.create_subnets ? length(var.subnet_names) : 0

  filter {
    name   = "tag:Name"
    values = [var.subnet_names[count.index]]
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = var.create_vpc ? aws_vpc.vpc[0].id : data.aws_vpc.vpc_data[0].id

  tags = {
    Name = "bowtie-igw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = var.create_vpc ? aws_vpc.vpc[0].id : data.aws_vpc.vpc_data[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "bowtie-rt"
  }
}

resource "aws_route_table_association" "subnet_rt_assoc" {
  count          = length(var.subnet_names)
  subnet_id      = var.create_subnets ? aws_subnet.subnets[count.index].id : data.aws_subnet.subnets_data[count.index].id
  route_table_id = aws_route_table.rt.id
}
