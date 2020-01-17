provider "kubernetes" {
  host                   = "${azurerm_kubernetes_cluster.thanoskubernetes.kube_config.0.host}"
  username               = "${azurerm_kubernetes_cluster.thanoskubernetes.kube_config.0.username}"
  password               = "${azurerm_kubernetes_cluster.thanoskubernetes.kube_config.0.password}"
  client_certificate     = "${base64decode(azurerm_kubernetes_cluster.thanoskubernetes.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(azurerm_kubernetes_cluster.thanoskubernetes.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.thanoskubernetes.kube_config.0.cluster_ca_certificate)}"
}

resource "kubernetes_namespace" "monitoringns" {
  metadata {
    annotations = {
      name = "monitoring"
    }

    name = "monitoring"
  }
}

resource "kubernetes_secret" "thanosobjectstoreconfig" {
  metadata {
    name = "thanos-objstore-config"
    namespace = "monitoring"
  }

  data = {
    "thanos.yaml" = "${file("local-thanos-storage-config.yaml")}"
  }
}
