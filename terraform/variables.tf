variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
  default     = "cdc-prd"
}

variable "environment" {
  description = "Environment name (staging, production)"
  type        = string
  
  validation {
    condition     = contains(["staging", "production"], var.environment)
    error_message = "Environment must be either 'staging' or 'production'."
  }
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "cdc"
}

variable "domain_name" {
  description = "Domain name for the website"
  type        = string
  
  validation {
    condition     = can(regex("^[a-z0-9.-]+$", var.domain_name))
    error_message = "Domain name must be a valid domain."
  }
}