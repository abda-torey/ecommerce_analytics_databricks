# Development Environment Configuration

terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  features {}
}

module "infrastructure" {
  source = "../../"
  
  project_name = var.project_name
  environment  = var.environment
  location     = var.location
  tags         = var.tags
}
