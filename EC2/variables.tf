variable "tags" {
  type = map(string)
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_az_1a" {
  type = string
}

variable "public_subnet_az_1b" {
  type = string
}

variable "alb_sg" {
  type = string
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "target_group_arns" {
  type = string
}
