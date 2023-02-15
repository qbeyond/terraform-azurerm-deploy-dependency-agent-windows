resource "azurerm_policy_definition" "windows_dependency_agent" {
  name = "DeployDepAgentWin"
  display_name = "Deploy Dependency Agent on Windows Machines"
  description  = "Includes 2022 images. Deploy Dependency agent for Windows virtual machines if the virtual machine image is in the list defined and the agent is not installed."
  policy_type  = "Custom"
  mode = "All"
  policy_rule = file("${path.module}/policy/azurepolicy.rules.json")
  parameters = file("${path.module}/policy/azurepolicy.parameters.json")
  management_group_id = var.management_group_id
} 

resource "azurerm_management_group_policy_assignment" "windows_dependency_agent" {
  name                 = "DeployDepAgentWin"
  policy_definition_id = azurerm_policy_definition.windows_dependency_agent.id
  management_group_id  = var.management_group_id
  location = var.location
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "log_analytics_contributor" {
  scope = var.management_group_id
  role_definition_id = "/providers/microsoft.authorization/roleDefinitions/92aaf0da-9dab-42b6-94a3-d43ce8d16293" # log analytics contributor
  principal_id       = azurerm_management_group_policy_assignment.windows_dependency_agent.identity[0].principal_id
}