provider "azurerm" {
  client_id = "bc88e2d6-fa1e-45ea-ad19-1bd01b50d6f7"
  client_secret=".5A8Q~8~hdj6ytl--BK2zIuZgN7sQJI~tItZoaf4"
  tenant_id="96d64ff8-d39d-4680-b775-97832211da59"
  subscription_id="ab443b87-f064-4cea-a781-1e20fa4b5140"
  features {}
}



terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.39.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.10.0"
    }
  }
}

provider "helm" {
  debug=true
  version= "2.7.1"
  kubernetes {
    host = azurerm_kubernetes_cluster.aks.kube_config[0].host

    client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)

  }
}

provider "kubectl" {
  version = ">= 1.7.0"
  host                   = data.azurerm_kubernetes_cluster.aks.kube_config[0].host
  client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
  load_config_file       = false
}