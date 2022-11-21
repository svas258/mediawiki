terraform {
  required_version = ">= 0.14"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.50.0"
    }
  }
}

provider "azurerm" {
  features {}
}
#Resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}
#vnet
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.address_space
  location            = azurerm_resource_group.rg.location
}

#subnets

resource "azurerm_subnet" "aks" {
  name                 = "${var.cluster_name}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  address_prefixes     = var.aks_node_prefix
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.firewall_prefix
}

#user assigned identity

resource "azurerm_user_assigned_identity" "idn" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = "${var.cluster_name}-idn"
}
#role assignment

resource "azurerm_role_assignment" "role" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.idn.principal_id
}
#route table

resource "azurerm_route_table" "rtable" {
  name                = "${var.cluster_name}-rtable"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

#route 

resource "azurerm_route" "route" {
  name                   = "${var.cluster_name}-route"
  resource_group_name    = azurerm_resource_group.rg.name
  route_table_name       = azurerm_route_table.rtable.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_firewall.fw.ip_configuration.0.private_ip_address
}

#route table association

resource "azurerm_subnet_route_table_association" "base" {
  subnet_id      = azurerm_subnet.aks.id
  route_table_id = azurerm_route_table.rtable.id
}

#firewall

resource "azurerm_public_ip" "pub" {
  name                = "${var.cluster_name}-pub"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "fw" {
  name                = "${var.cluster_name}-fw"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "${var.cluster_name}-ip"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.pub.id
  }
}

#kubernetes_cluster

resource "azurerm_kubernetes_cluster" "base" {
  name                    = var.cluster_name
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  dns_prefix              = var.cluster_name
  private_cluster_enabled = true

  network_profile {
    network_plugin = "azure"
    outbound_type  = "userDefinedRouting"
  }


  default_node_pool {
    name           = var.nodepool_name
    node_count     = var.system_node_count
    vm_size        = "Standard_D2_v2"
    enable_auto_scaling = false
    vnet_subnet_id = azurerm_subnet.aks.id
  }
    identity {
     type = "UserAssigned"
     identity_ids = [azurerm_user_assigned_identity.idn.id]
  } 
}