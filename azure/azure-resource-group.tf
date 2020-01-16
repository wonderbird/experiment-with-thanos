provider "azurerm" {
    version = "~>1.38.0"
}

resource "azurerm_resource_group" "thanosresources" {
    name     = "thanosrg"
    location = "westeurope"
}
