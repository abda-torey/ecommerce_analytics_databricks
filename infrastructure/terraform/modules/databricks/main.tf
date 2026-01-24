# Databricks Module

resource "azurerm_databricks_workspace" "main" {
  name                = "${var.project_name}-databricks-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.environment == "prod" ? "premium" : "standard"
  
  tags = merge(var.tags, {
    Environment = var.environment
    Project     = var.project_name
  })
}
