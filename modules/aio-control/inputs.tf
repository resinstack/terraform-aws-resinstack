variable "machine_count" {
  type        = number
  description = "Number of control machines to run."
  default     = 3
}

variable "machine_size" {
  type        = string
  description = "Size of machine to use."
  default     = "t3.medium"
}

variable "ami" {
  type        = string
  description = "AMI containing the All-In-One controller image."
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC to create security groups in."
}

variable "vpc_subnets" {
  type        = list(string)
  description = "List of VPC subnets to launch machines in."
}

variable "user_data" {
  type        = string
  description = "LinuxKit formatted metadata string."
}

variable "instance_profile" {
  type        = string
  description = "The profile to assign to each controller."
}

variable "common_sg" {
  type        = string
  description = "A security group which will be applied to all machines."
}

variable "key_name" {
  type        = string
  description = "The name of a key-pair to associate to the machines."
}
