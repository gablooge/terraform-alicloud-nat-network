output "this_eip_snat_ids" {
  description = "The id of new eips."
  value       = module.vpc-nat.this_eip_snat_ids
}

output "this_eip_snat_ips" {
  description = "The id of new eip addresses."
  value       = module.vpc-nat.this_eip_snat_ips
}

output "this_eip_dnat_ids" {
  description = "The id of new eips."
  value       = module.vpc-nat.this_eip_dnat_ids
}

output "this_eip_dnat_ips" {
  description = "The id of new eip addresses."
  value       = module.vpc-nat.this_eip_dnat_ips
}

output "this_snat_table_id" {
  description = "The snat table id in this nat gateway."
  value       = module.vpc-nat.this_snat_table_id
}

output "this_vswitch_ids" {
  description = "List of IDs of vswitch."
  value       = module.vpc-nat.this_vswitch_ids
}

output "this_forward_table_id" {
  description = "The forward table id in this nat gateway. Seem as 'this_dnat_table_id'."
  value       = module.vpc-nat.this_forward_table_id
}

output "this_vpc_id" {
  description = "The ID of the VPC."
  value       = module.vpc-nat.this_vpc_id
}

output "this_nat_gateway_id" {
  description = "The nat gateway id."
  value       = module.vpc-nat.this_nat_gateway_id
}