variable "data_safe_subsetting_policy_subsetting_rules" {
  description = <<EOT
Map of data_safe_subsetting_policy_subsetting_rules, attributes below
Required:
    - subsetting_policy_id
    - scope (block):
        - object (optional)
        - schema_name (required)
        - scope_type (required)
    - subset_rule_entry (block):
        - condition (optional)
        - partitions_list (optional)
        - percent (optional)
        - rule_type (required)
        - sub_partitions_list (optional)
Optional:
    - description
    - display_name
    - peer_tables_action
    - related_tables_propagation
    - rule_combination_mode
    - timeouts (block):
        - create (optional)
        - delete (optional)
        - update (optional)
EOT

  type = map(object({
    subsetting_policy_id       = string
    description                = optional(string)
    display_name               = optional(string)
    peer_tables_action         = optional(string)
    related_tables_propagation = optional(string)
    rule_combination_mode      = optional(string)
    scope = object({
      object      = optional(string)
      schema_name = string
      scope_type  = string
    })
    subset_rule_entry = object({
      condition           = optional(string)
      partitions_list     = optional(list(string))
      percent             = optional(number)
      rule_type           = string
      sub_partitions_list = optional(list(string))
    })
    timeouts = optional(object({
      create = optional(string)
      delete = optional(string)
      update = optional(string)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.data_safe_subsetting_policy_subsetting_rules : (
        length(v.scope.schema_name) >= 1 && length(v.scope.schema_name) <= 128
      )
    ])
    error_message = "must be between 1 and 128 characters"
  }
  validation {
    condition = alltrue([
      for k, v in var.data_safe_subsetting_policy_subsetting_rules : (
        contains([for v in ["ALL", "SPECIFIC"] : lower(v)], lower(v.scope.scope_type))
      )
    ])
    error_message = "must be one of: \"ALL\", \"SPECIFIC\""
  }
  validation {
    condition = alltrue([
      for k, v in var.data_safe_subsetting_policy_subsetting_rules : (
        v.scope.object == null || (length(v.scope.object) >= 1 && length(v.scope.object) <= 128)
      )
    ])
    error_message = "must be between 1 and 128 characters"
  }
  validation {
    condition = alltrue([
      for k, v in var.data_safe_subsetting_policy_subsetting_rules : (
        contains([for v in ["CONDITION", "PARTITION", "PERCENT"] : lower(v)], lower(v.subset_rule_entry.rule_type))
      )
    ])
    error_message = "must be one of: \"CONDITION\", \"PARTITION\", \"PERCENT\""
  }
  validation {
    condition = alltrue([
      for k, v in var.data_safe_subsetting_policy_subsetting_rules : (
        v.subset_rule_entry.percent == null || (v.subset_rule_entry.percent >= 0 && v.subset_rule_entry.percent <= 100)
      )
    ])
    error_message = "must be between 0 and 100"
  }
  validation {
    condition = alltrue([
      for k, v in var.data_safe_subsetting_policy_subsetting_rules : (
        v.peer_tables_action == null || (contains([for v in ["MINIMUM_ROWS", "SUBSET", "MAXIMUM_ROWS"] : lower(v)], lower(v.peer_tables_action)))
      )
    ])
    error_message = "must be one of: \"MINIMUM_ROWS\", \"SUBSET\", \"MAXIMUM_ROWS\""
  }
  validation {
    condition = alltrue([
      for k, v in var.data_safe_subsetting_policy_subsetting_rules : (
        v.related_tables_propagation == null || (contains([for v in ["ANCESTORS_AND_DESCENDANTS", "ANCESTORS", "DESCENDANTS", "NONE"] : lower(v)], lower(v.related_tables_propagation)))
      )
    ])
    error_message = "must be one of: \"ANCESTORS_AND_DESCENDANTS\", \"ANCESTORS\", \"DESCENDANTS\", \"NONE\""
  }
  validation {
    condition = alltrue([
      for k, v in var.data_safe_subsetting_policy_subsetting_rules : (
        v.rule_combination_mode == null || (contains([for v in ["UNION", "SERIAL"] : lower(v)], lower(v.rule_combination_mode)))
      )
    ])
    error_message = "must be one of: \"UNION\", \"SERIAL\""
  }
}

