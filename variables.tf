variable "name_prefix" {
  description = "[REQUIRED] Prefix to be used in resource naming and tagging"
  type        = string
}

variable "vpc_id" {
  type        = string
  description = "[REQUIRED] The ID of the VPC where the resources should be deployed"

  validation {
    condition     = can(regex("^vpc-*", var.vpc_id))
    error_message = "[ERROR] The VPC ID must start with the prefix 'vpc-'"
  }
}

variable "public_subnet" {
  type        = list(string)
  description = "[REQUIRED] A list of public subnet IDs"

  validation {
    condition     = length(var.public_subnet) > 1
    error_message = "[ERROR] This application requires at least two subnets."
  }
}

variable "private_subnet" {
  type        = list(string)
  description = "[REQUIRED] A list of private subnet IDs"

  validation {
    condition     = length(var.private_subnet) > 1
    error_message = "[ERROR] This application requires at least two subnets."
  }
}

variable "node_groups" {
  description = "[REQUIRED] List of key value map attributes for node group definition"
  type = list(object({
    name    = string
    desired = number
    max     = number
    min     = number
  }))
}

variable "logs_retention" {
  description = "[REQUIRED] The number of days to retain log events in CloudWatch"
  type        = number

  validation {
    condition = (
      var.logs_retention == 0 ||
      var.logs_retention == 1 ||
      var.logs_retention == 3 ||
      var.logs_retention == 5 ||
      var.logs_retention == 7 ||
      var.logs_retention == 14 ||
      var.logs_retention == 30 ||
      var.logs_retention == 60 ||
      var.logs_retention == 90 ||
      var.logs_retention == 120 ||
      var.logs_retention == 150 ||
      var.logs_retention == 180 ||
      var.logs_retention == 365 ||
      var.logs_retention == 400 ||
      var.logs_retention == 545 ||
      var.logs_retention == 731 ||
      var.logs_retention == 1827 ||
      var.logs_retention == 3653
    )
    error_message = "[ERROR] The value must be one of the followings: 0,1,3,5,7,14,30,60,90,120,150,180,365,400,545,731,1827,3653."
  }
}

variable "cluster_log_type" {
  type = list(string)
  validation {
    condition     = contains(["api", "audit", "authenticator", "controllerManager", "scheduler"], var.cluster_log_type)
    error_message = "[ERROR] Allowed values are: api, audit, authenticator, controllerManager, scheduler"
  }
}

variable "use_external_role" {
  type        = bool
  description = "[REQUIRED] If set to true and external IAM Role ARN must be provided"
}

variable "cluster_role_arn" {
  type        = string
  description = "[REQUIRED] The Cluster IAM Role ARN"

  validation {
    condition     = can(regex("^arn:aws:iam::*", var.cluster_role_arn))
    error_message = "[ERROR] The IAM Role ARN must start with the prefix 'arn:aws:iam::'"
  }
}

variable "node_role_arn" {
  type        = string
  description = "[REQUIRED] The Node IAM Role ARN"

  validation {
    condition     = can(regex("^arn:aws:iam::*", var.node_role_arn))
    error_message = "[ERROR] The IAM Role ARN must start with the prefix 'arn:aws:iam::'"
  }
}

variable "cluster_version" {
  type        = string
  description = "The desired Kubernetes master version"

  validation {
    condition     = contains(["1.21", "1.22", "1.23", "1.24"], var.cluster_version)
    error_message = "[ERROR] Allowed values are: 1.21, 1.22, 1.23, 1.24"
  }
}

variable "encryption_config" {
  type = map
}

variable "instance_type" {
  type = list
}