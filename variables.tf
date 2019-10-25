variable "aws_access_key" {
  type    = "string"
}

variable "aws_secret_key" {
  type    = "string"
}

variable "ami" {
  type    = "string"
  default = "ami-006219aba10688d0b"
}

variable "instance_type" {
  type    = "string"
  default = "t2.medium"
}


variable "security_group_id" {
  type        = "string"
  description = "The AWS security group with ingress and egress rules for this instance."
  default     = "sg-21bb1371"
}
