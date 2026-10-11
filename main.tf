resource "oci_data_safe_subsetting_policy_subsetting_rule" "data_safe_subsetting_policy_subsetting_rules" {
  for_each = var.data_safe_subsetting_policy_subsetting_rules

  subsetting_policy_id       = each.value.subsetting_policy_id
  description                = each.value.description
  display_name               = each.value.display_name
  peer_tables_action         = each.value.peer_tables_action
  related_tables_propagation = each.value.related_tables_propagation
  rule_combination_mode      = each.value.rule_combination_mode

  scope {
    object      = each.value.scope.object
    schema_name = each.value.scope.schema_name
    scope_type  = each.value.scope.scope_type
  }

  subset_rule_entry {
    condition           = each.value.subset_rule_entry.condition
    partitions_list     = each.value.subset_rule_entry.partitions_list
    percent             = each.value.subset_rule_entry.percent
    rule_type           = each.value.subset_rule_entry.rule_type
    sub_partitions_list = each.value.subset_rule_entry.sub_partitions_list
  }

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      update = timeouts.value.update
    }
  }
}

