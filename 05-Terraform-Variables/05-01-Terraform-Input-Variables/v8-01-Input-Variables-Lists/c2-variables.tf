# Input Variables
variable "aws_region" {
  description = "Region in which AWS resources to be created"
  type        = string
  default     = "ap-south-1"
}

variable "ec2_ami_id" {
  description = "AMI ID"
  type        = string
  default     = "ami-04db49c0fb2215364" # Amazon2 Linux AMI ID
}

variable "ec2_instance_count" {
  description = "EC2 Instance Count"
  type        = number
  default     = 1
}

variable "ec2_instance_type" {
  description = "EC2 Instance Type"
  type = list(string)
  default = ["t2.micro", "t3.small", "t3.large"]
}