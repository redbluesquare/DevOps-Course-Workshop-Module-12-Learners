terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">=3.43.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "d33b95c7-af3c-4247-9661-aa96d47fccc0"
}

data "azurerm_resource_group" "main" {
  name = "Cohort31_DarUsh_Workshop_M12_Pt2"
}

resource "azurerm_service_plan" "main" {
  name                = "darush-terraformed-asp"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = "B1"
}


resource "azurerm_linux_web_app" "main" {
  name                = "darush-terraformed-asp-webapp"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = resource.azurerm_service_plan.main.location
  service_plan_id     = resource.azurerm_service_plan.main.id
  site_config {
    application_stack {
      docker_image_name     = "corndeldevopscourse/mod12app:latest"
      docker_registry_url   = "https://index.docker.io"
    }
  }

  app_settings = {
    "SCM_DO_BUILD_DURING_DEPLOYMENT" : "True"
    "DEPLOYMENT_METHOD" : "Terraform"
    "CONNECTION_STRING" : "Server=tcp:darush-non-iac-sqlserver.database.windows.net,1433;Initial Catalog=darush-non-iac-db;Persist Security Info=False;User ID=dbadmin;Password=${var.database_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }
  }
}

