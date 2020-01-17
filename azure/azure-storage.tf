resource "azurerm_storage_account" "thanosstorage" {
  name                     = "thanossa"
  resource_group_name      = "${azurerm_resource_group.thanosresources.name}"
  location                 = "${azurerm_resource_group.thanosresources.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  enable_file_encryption   = "true"

  provisioner "local-exec" {
    command = "create_thanos_storage_config.sh"
    interpreter = ["bash"]
    environment = {
      RESOURCE_GROUP = "${azurerm_resource_group.thanosresources.name}"
      STORAGE_ACCOUNT = "${azurerm_storage_account.thanosstorage.name}"
      TARGET_FILE = "local-thanos-storage-config.yaml"
    }
  }
}

resource "azurerm_storage_container" "thanoscontainer" {
  name                  = "thanos"
  resource_group_name   = "${azurerm_resource_group.thanosresources.name}"
  storage_account_name  = "${azurerm_storage_account.thanosstorage.name}"
  container_access_type = "private"
}
