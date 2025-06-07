variable "vpc_id" {
  type = string
}

variable "tags" {
  type = map(string)
}


variable "public_subnet_az_1a" {
  type = string
}

variable "public_subnet_az_1b" {
  type = string
}

variable "ssl_policy" {
  type = string
}

variable "certificate_arn" {
  type = string
}
