variable "resource_group_name" {
  type        = string
  description = "RG name in Azure"
}
variable "location" {
  type        = string
  description = "Resources location in Azure"
}
variable "cluster_name" {
  type        = string
  description = "AKS name in Azure"
}
variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
}
variable "system_node_count" {
  type        = number
  description = "Number of AKS worker nodes"
}
variable "vnet_name" { 
  type        = string
  description = "vnet name"
}

variable "address_space" {
  type        = list(string)
  description = "address_space ip"
}

variable "aks_node_prefix" {
  type        = list(string)
  description = "subnet ip"
}

variable "firewall_prefix" {
  type        = list(string)
  description = "firewall subnet ip"
}

variable "nodepool_name" {
  type        = string
  description = "nodepool_name"
}
