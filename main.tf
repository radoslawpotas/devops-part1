# Configure the Azure provider
terraform {
  required_version = ">= 0.14.9"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tf_main_storage"
    storage_account_name = "tfmainstorageaccount"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "tf_resource" {
  name     = "tfmainrg"
  location = "West Europe"
}


resource "azurerm_container_group" "tf_container_group" {
  name                = "tfcontainergroup"
  resource_group_name = azurerm_resource_group.tf_resource.name
  location            = azurerm_resource_group.tf_resource.location

  ip_address_type = "public"
  dns_name_label  = "radoslawdevops"
  os_type         = "Linux"

  container {
    name   = "weatherapi"
    image  = "radoslawpotas/devops.weatherapi"
    cpu    = 1
    memory = 1

    ports {
      protocol = "TCP"
      port     = 80

    }
  }
}
