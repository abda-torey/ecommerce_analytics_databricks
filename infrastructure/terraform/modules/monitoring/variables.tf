variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "storage_account_id" {
  description = "Storage account resource ID for diagnostics"
  type        = string
}

variable "eventhub_namespace_id" {
  description = "Event Hub namespace resource ID for diagnostics"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
