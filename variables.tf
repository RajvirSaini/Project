variable "access_key" {
  default = "(my_access_key)"
}

variable "secret_key" {
  default = "(my_secret_key)"
}

variable "ami" {
  default = "ami-04bde106886a53080"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "region" {
  default = "ap-south-1"
}

variable "vpc-cidr" {
  default = "10.0.0.0/16"
}

variable "public1-cidr" {
  default = "10.0.1.0/24"
}

variable "private1-cidr" {
  default = "10.0.3.0/24"
}

variable "vpc-name" {
  default = "rajvir-vpc"
}

variable "subnet1-name" {
  default = "rajvir-public1"
}

variable "subnet3-name" {
  default = "rajvir-private1"
}

variable "igw-name" {
  default = "rajvir-igw"
}

variable "nateip-name" {
  default = "rajvir-nat-ip"
}

variable "nat-name" {
  default = "rajvir-nat-gateway"
}

variable "public-rt" {
  default = "rajvir-public-rt"
}


variable "private-rt" {
  default = "rajvir-private-rt"
}


variable "public-sg-name" {
  default = "rajvir-public-sg"
}


variable "private-sg-name" {
  default = "rajvir-private-sg"
}


variable "instance-name" {
  default = "rajvir-instance"
}

variable "aws-launch-name" {
  default = "rajvir-ln"
}


variable "auto-name" {
  default = "rajvirautoscalinggroup"
}


variable "min-size" {
  default = "1"
}


variable "max-size" {
  default = "1"
}


variable "health-check-type" {
  default = "EC2"
}
























