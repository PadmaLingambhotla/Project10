provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Custom Role Definition
resource "azurerm_role_definition" "custom_role" {
  name        = "CustomRole"
  description = "Custom role with limited permissions"
  scope       = "/subscriptions/${var.subscription_id}"

  permissions {
    actions     = ["Microsoft.Storage/storageAccounts/read"]
    not_actions = []
  }

  assignable_scopes = ["/subscriptions/${var.subscription_id}"]
}

# Custom Policy Definition
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

# Policy Assignment
resource "azurerm_subscription_policy_assignment" "custom_policy_assignment" {
  name                 = "customPolicyAssignment5"
  policy_definition_id = azurerm_policy_definition.custom_policy.id
  subscription_id      = var.subscription_id
}

# Role Assignment with Dependency
resource "azurerm_role_assignment" "custom_role_assignment" {
  principal_id         = var.principal_id
  role_definition_name = azurerm_role_definition.custom_role.name
  scope                = "/subscriptions/${var.subscription_id}"

  depends_on = [
    azurerm_role_definition.custom_role,
    azurerm_policy_definition.custom_policy
  ]
}
