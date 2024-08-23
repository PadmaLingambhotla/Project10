# variables.tf

variable "subscription_id" {
  description = "The ID of the Azure subscription"
  type        = string
}

variable "principal_id" {
  description = "The ID of the principal to assign the role"
  type        = string
}