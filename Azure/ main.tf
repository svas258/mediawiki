resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_role_assignment" "role_acrpull" {
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity.0.object_id
  skip_service_principal_aad_check = true
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = false
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.cluster_name

  default_node_pool {
    name                = "testpool"
    node_count          = var.system_node_count
    vm_size             = "Standard_DS2_v2"
    type                = "VirtualMachineScaleSets"
    availability_zones  = [1, 2]
    enable_auto_scaling = false
  }

  identity {
    type = "SystemAssigned"
  }
  addon_profile {
    http_application_routing {
      enabled = true
    }
    }
  network_profile {
    load_balancer_sku = "Standard"
    network_plugin    = "kubenet" 
  }
}



#resource "kubernetes_namespace" "demo" {
#  metadata {
#    annotations = {
#      name = "demo-annotation"
#    }

#    labels = {
#      mylabel = "label-value"
#    }

#    name = "ingress-nginx"
#  }
#}

resource "helm_release" "ingress" {
  name  = "ingress"
  namespace = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart = "ingress-nginx"
  set {
    name  = "rbac.create"
    value = "true"
  }
}

#resource "helm_release" "mediawiki" {
 # name  = "mediawiki"
  #repository       = "https://charts.bitnami.com/bitnami"
  #chart = "mediawiki"
  #set {
   # name  = "rbac.create"
    #value = "true"
  #}
#}