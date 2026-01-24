# Main Terraform Configuration
# This file orchestrates all modules

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

  # Uncomment for remote state (after initial setup)
  # backend "azurerm" {
  #   resource_group_name  = "terraform-state-rg"
  #   storage_account_name = "tfstate<unique>"
  #   container_name       = "tfstate"
  #   key                  = "ecommerce-analytics.tfstate"
  # }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

# Random suffix for globally unique names
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Resource Group Module
module "resource_group" {
  source = "./modules/resource-group"
  
  project_name = var.project_name
  environment  = var.environment
  location     = var.location
  tags         = var.tags
}

# Storage Module
module "storage" {
  source = "./modules/storage"
  
  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = module.resource_group.name
  random_suffix       = random_string.suffix.result
  tags                = var.tags
}

# Event Hubs Module
module "eventhubs" {
  source = "./modules/eventhubs"
  
  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = module.resource_group.name
  tags                = var.tags
}

# Data Factory Module
module "datafactory" {
  source = "./modules/datafactory"
  
  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = module.resource_group.name
  tags                = var.tags
}

# Databricks Module
module "databricks" {
  source = "./modules/databricks"
  
  project_name        = var.project_name
  environment         = var.environment
  location            = var.location
  resource_group_name = module.resource_group.name
  tags                = var.tags
}

# Monitoring Module
module "monitoring" {
  source = "./modules/monitoring"
  
  project_name         = var.project_name
  environment          = var.environment
  location             = var.location
  resource_group_name  = module.resource_group.name
  storage_account_id   = module.storage.storage_account_id
  eventhub_namespace_id = module.eventhubs.namespace_id
  tags                 = var.tags
}
