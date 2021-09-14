resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr_block
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr_block
}

// public subnet�� ���ͳݰ� �����ϴ� Internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

// NAT gateway ���� ����� public IP ����
resource "aws_eip" "nat" {
  vpc = true
}

// private subnet�� ���ͳݰ� �����ϴ� NAT gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id
}

// Internet gateway �� ����Ǵ� public route table,
// NAT gateway �� ����Ǵ� private route table ����
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
}

//������ route table �� ���� public, private subnet �� ����
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
