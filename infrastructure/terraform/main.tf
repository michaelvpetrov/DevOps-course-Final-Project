provider "aws" {
  region = var.region
}

# Create a VPC
resource "aws_vpc" "proj_vpc" {  
  cidr_block           = "172.16.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "proj-vpc"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "proj_igw" {
  vpc_id = aws_vpc.proj_vpc.id
  tags = {
    Name = "proj-igw"
  }
}

# Create a Route Table
resource "aws_route_table" "proj_route_table" {
  vpc_id = aws_vpc.proj_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.proj_igw.id
  }
  tags = {
    Name = "proj-route-table"
  }
}

# Create a Subnet
resource "aws_subnet" "proj_subnet" {
  vpc_id            = aws_vpc.proj_vpc.id
  cidr_block        = "172.16.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone
  tags = {
    Name = "proj-subnet"
  }
}

# Associate Subnet with Route Table
resource "aws_route_table_association" "proj_rta" {
  subnet_id      = aws_subnet.proj_subnet.id
  route_table_id = aws_route_table.proj_route_table.id
}

# Create a Security Group
resource "aws_security_group" "proj_sg" {
  name        = "proj-sg"
  description = "Allow SSH, HTTP, and HTTPS" 
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id      = aws_vpc.proj_vpc.id
 
  tags = {
    Name = "proj-sg"
  }
}

resource "aws_instance" "jenkins_master" {
  ami           = var.jenkins_ami
  instance_type = var.jenkins_instance_type
  vpc_security_group_ids= [aws_security_group.proj_sg.id]
  subnet_id     = aws_subnet.proj_subnet.id
  tags = {
    Name = "Jenkins-Master"
  }
  user_data = file("./scripts/installJenkins.sh")  
  associate_public_ip_address = true
}

resource "aws_instance" "jenkins_worker" {
  count         = var.worker_count
  ami           = var.worker_ami
  instance_type = var.worker_instance_type
  vpc_security_group_ids= [aws_security_group.proj_sg.id]
  subnet_id     = aws_subnet.proj_subnet.id
  tags = {
    Name = "Jenkins-Worker-${count.index}"
  }  
  user_data = file("./scripts/add-worker.sh")
  associate_public_ip_address = true
}

output "jenkins_master_public_ip" {
  value = aws_instance.jenkins_master.public_ip
}

