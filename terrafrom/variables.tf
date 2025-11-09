variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}
variable "ami_id" {
  description = "Amazon Linux for us-east-1 (supports Docker)"
  type        = string
  default     = "ami-0bdd88bd06d16ba03"
}

variable "instance_type" {
  default = "t3.micro" 
}
