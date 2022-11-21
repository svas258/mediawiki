resource_group_name = "AKS_cluster"
location            = "East US"
cluster_name        = "srinicluster"
kubernetes_version  = "1.23.12"
system_node_count   = 2
vnet_name = "clustervnet"
address_space=["10.200.0.0/16"]
aks_node_prefix=["10.200.0.0/24"]
firewall_prefix=["10.200.1.0/24"]
nodepool_name="akspool"





