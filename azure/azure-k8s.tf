resource "azurerm_kubernetes_cluster" "thanoskubernetes" {
  name                = "thanosk8s"
  location            = azurerm_resource_group.thanosresources.location
  resource_group_name = azurerm_resource_group.thanosresources.name
  dns_prefix          = "sboosthanos"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  service_principal {
    client_id     = "${var.client_id}"
    client_secret = "${var.client_secret}"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.thanoskubernetes.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.thanoskubernetes.kube_config_raw
}