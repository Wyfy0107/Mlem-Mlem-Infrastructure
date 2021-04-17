data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "mlem-mlem" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "mlem-mlem-vpc"
  }
}

resource "aws_subnet" "public" {
  count             = 4
  vpc_id            = aws_vpc.mlem-mlem.id
  cidr_block        = var.public_subnets_cidr[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "mlem-mlem-subnet"
  }

}

resource "aws_internet_gateway" "mlem-mlem" {
  vpc_id = aws_vpc.mlem-mlem.id
  depends_on = [
    aws_vpc.mlem-mlem
  ]

  tags = {
    Name = "mlem-mlem-gateway"
  }
}

resource "aws_route_table" "mlem-mlem" {
  vpc_id = aws_vpc.mlem-mlem.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mlem-mlem.id
  }

  tags = {
    Name = "routetable_demo"
  }
}

resource "aws_route_table_association" "mlem-mlem" {
  count          = 4
  route_table_id = aws_route_table.mlem-mlem.id
  subnet_id      = aws_subnet.public[count.index].id
}
