resource "azurerm_resource_group" "resourcegroup" {
    name    = var.name
    location= var.location
    tags = {
        diplomado = var.name
    }
}

resource "azurerm_public_ip" "publicip" {
    name = var.ippublica
    resource_group_name = azurerm_resource_group.resourcegroup.name
    location = azurerm_resource_group.resourcegroup.location
    allocation_method = "Static"
  
}


resource "azurerm_virtual_network" "virtualnetwork"{
    name =var.network
    address_space = ["56.0.0.0/16"]
    resource_group_name  = azurerm_resource_group.resourcegroup.name
    location = azurerm_resource_group.resourcegroup.location
}

resource "azurerm_subnet" "subnet"{
    name =var.subnet
    address_prefixes = ["56.0.0.0/24"]
    resource_group_name  = azurerm_resource_group.resourcegroup.name
    virtual_network_name = azurerm_virtual_network.virtualnetwork.name
}

resource "azurerm_container_registry" "acr" {
    name = var.container
    resource_group_name  = azurerm_resource_group.resourcegroup.name
    location = azurerm_resource_group.resourcegroup.location
    sku = "basic"
    admin_enabled = true
}

resource "azurerm_kubernetes_cluster" "aks" {
    name = var.aks
    resource_group_name = azurerm_resource_group.resourcegroup.name
    #virtual_network_name = azurerm_virtual_network.virtualnetwork.name
     
    dns_prefix = "aks1"
    location = azurerm_resource_group.resourcegroup.location

    kubernetes_version = var.kubernetesversion

    default_node_pool {
      name ="default"
      node_count = 1
      vm_size ="Standard_D2_v2"
      enable_auto_scaling = var.enableautoscaling
      max_count = var.nodomax
      min_count = var.nodomin
    }

    service_principal {
      client_id ="3aae846a-bd37-4552-8859-e75397b929c4"
      client_secret="SFx~R_-oswoY3M.NbCYr915-p6-rp17-6G"

    }

    network_profile {
        network_plugin = "azure"
        network_policy = "azure"
    }

    role_based_access_control {
        enabled = true
    }


}

    resource "azurerm_kubernetes_cluster_node_pool" "nodepool" {
        name= var.nodoadicionalname
        kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
        vm_size = "Standard_DS2_v2"
        max_pods = var.nodoadicionalpods
        node_labels = var.nodoadicionallabel
        node_count = 1
        tags = {
            Environment = "Produccion"
        } 
  
    }

resource "azurerm_network_interface" "networkinterface" {
    name = var.networkinterface
    resource_group_name  = azurerm_resource_group.resourcegroup.name
    location = azurerm_resource_group.resourcegroup.location

    ip_configuration {
        name=var.nameinternal
        subnet_id = azurerm_subnet.subnet.id
        private_ip_address_allocation ="Dynamic"
        public_ip_address_id = azurerm_public_ip.publicip.id
    }

}

#parametros infraestructura
variable "name" {}
variable "location" {}
variable "ippublica" {}
variable "network" {}
variable "subnet" {}
variable "container" {}
variable "aks" {}
variable "networkinterface" {}
variable "nameinternal" {}
# parametros Tarea
variable "kubernetesversion" {}
variable "enableautoscaling" {}
variable "nodomax" {}
variable "nodomin" {}
variable "nodoadicionalname" {}
variable "nodoadicionalpods" {}
variable "nodoadicionallabel" {}