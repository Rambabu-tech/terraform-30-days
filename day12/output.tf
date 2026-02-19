output "formatted_project_name" {
    value = local.formatted_project_name
  
}

output "port_list" {
    value = local.port_list
  
}
output "sg_rules" {
    value = local.sg_rules
  
}

output "instance_size" {
    value = local.instance_size
  
}

output "credentials" {
    value = var.credentials
    sensitive = true
  
}
output "all_locations" {
    value = local.all_locations
  
}
output "unique_locations" {
    value = local.unique_locations
  
}

output "positive_costs" {
    value = local.positive_costs
  
}
output "max_cost" {
    value = local.max_cost
  
}
output "min_cost" {
    value = local.min_cost
  
}
output "total_cost" {
    value = local.total_cost 
}
output "avg_cost" {
    value = local.avg_cost 
}

output "current_time" {
    value = local.current_time 
}