# environment variables
variable "region" {
  description = "region to create resources"
  type        = string
}

variable "project_name" {
  description = "project name "
  type        = string
}

variable "environment" {
  description = "name of enviroment"
  type        = string
}

#vpc variables
variable "vpc_cidr" {
  description = "vpc cidr block"
  type        = string
}

variable "public_subnet_az1_cidr" {
  description = "public subnet az1 block"
  type        = string
}

variable "public_subnet_az2_cidr" {
  description = "public subnet az2 block"
  type        = string
}

variable "private_app_subnet_az1_cidr" {
  description = "private app subnet az1 block"
  type        = string
}

variable "private_app_subnet_az2_cidr" {
  description = "private app subnet az2 block"
  type        = string
}

variable "private_data_subnet_az1_cidr" {
  description = "private data subnet az1 block"
  type        = string
}

variable "private_data_subnet_az2_cidr" {
  description = "private data subnet az2 block"
  type        = string
}



variable "ami_id" {
  description = "The ID of the AMI to use for the EC2 instance"
  type        = string
}

variable "ec2_instance_type" {
  description = "The EC2 instance type."
  type        = string
}

variable "ec2_key_pair_name" {
  description = "EC2 instance key"
  type        = string
}

variable "max_size" {
  description = "Maximum size of the ASG"
  type        = number
}

variable "desired_capacity" {
  description = "Desired capacity of the ASG"
  type        = number
}

variable "min_size" {
  description = "Minimum size of the ASG"
  type        = number
}

variable "launch_template_name" {
  description = "Name of the launch template used to provision ec2"
  type        = string
}

variable "config" {
  description = "Chain on which Nethermind will be running"
  type = string
}

variable "rpc_enabled" {
  description = "Specify whether JSON RPC should be enabled"
  type = bool
}