variable "vpc_cidr_block" {
  type = string
}

variable "public_cidr_block" {
  type = list(string)
}

variable "private_cidr_block" {
  type = list(string)
}

variable "backend_cidr_block" {
  type = list(string)
}

variable "availability_zone" {
  type = list(string)
}

variable "ssl_policy" {
  type = string
}

variable "certificate_arn" {
  type = string
}