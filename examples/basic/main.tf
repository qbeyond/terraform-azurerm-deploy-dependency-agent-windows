provider "azurerm" {
  features {}
}

module "dependencyAgentWindowsPolicy" {
  source                      = "../../"
  management_group_id = "/providers/Microsoft.Management/managementGroups/myManagementGroup"
}