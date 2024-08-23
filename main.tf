provider "azurerm" {
  features {}
}

# Automatically retrieve the subscription ID
data "azurerm_client_config" "current" {}

resource "azurerm_role_definition" "custom_role" {
  name        = "CustomRole"
  description = "Custom role with limited permissions"
  scope       = data.azurerm_client_config.current.subscription_id

  permissions {
    actions     = ["Microsoft.Storage/storageAccounts/read"]
    not_actions = []
  }

  assignable_scopes = [data.azurerm_client_config.current.subscription_id]
}

resource "azurerm_policy_definition" "custom_policy" {
  name         = "CustomPolicy5"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Custom Policy"

  policy_rule = <<POLICY
  {
    "if": {
      "field": "location",
      "notIn": ["eastus", "westus"]
    },
    "then": {
      "effect": "deny"
    }
  }
  POLICY
}

resource "azurerm_subscription_policy_assignment" "custom_policy_assignment" {
  name                 = "customPolicyAssignment5"
  policy_definition_id = azurerm_policy_definition.custom_policy.id
  subscription_id      = data.azurerm_client_config.current.subscription_id
}

resource "azurerm_role_assignment" "custom_role_assignment" {
  principal_id         = var.principal_id
  role_definition_name = azurerm_role_definition.custom_role.name
  scope                = data.azurerm_client_config.current.subscription_id

  depends_on = [azurerm_role_definition.custom_role]
}
