# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=2.20.0"
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "octozen-resource-group"
  location = "West US"
}

resource "azurerm_storage_account" "octozenstorage" {
  name                     = "octozenstorage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "GRS"
  enable_https_traffic_only = true

  static_website {
    index_document = "index.html"
    error_404_document = "error.html"
  }
}