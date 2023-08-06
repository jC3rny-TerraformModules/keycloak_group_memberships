
# keycloak_realm
variable "keycloak_realm_name" {
  type = string
  #
  default = ""
}

# keycloak_group_memberships
variable "keycloak_group_memberships" {
  type = map(list(string))
  #
  default = {}
}
