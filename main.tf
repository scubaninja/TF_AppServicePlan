provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "RG-AppService"
  location = "West Europe"
}


## Deployment of Windows App Service Plan
resource "azurerm_app_service_plan" "windows" {
  name                = "appsvcplanwindows"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "windows" {
  name                = "windowstestwa007"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.windows.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }
}


## Deployment of Linux App Service Plan - Need to deploy the Windows and Linux plans into the same RG
resource "azurerm_app_service_plan" "linux" {
  name                = "appsvcplanlinux"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "linux" {
  name                = "linuxtestwa007"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.linux.id

  site_config {
    dotnet_framework_version = "v4.0"
    remote_debugging_enabled = true
    remote_debugging_version = "VS2019"
  }
}