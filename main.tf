
locals {}


data "keycloak_realm" "this" {
  realm = var.keycloak_realm_name
}


data "keycloak_user" "user" {
  for_each = { for k, v in distinct(flatten([for obj in var.keycloak_group_memberships : obj])) : v => {} }
  #
  realm_id = data.keycloak_realm.this.id
  #
  username = each.key
  #
  depends_on = [
    data.keycloak_realm.this
  ]
}

resource "keycloak_group" "group" {
  for_each = { for k, v in var.keycloak_group_memberships : k => {} }
  #
  realm_id = data.keycloak_realm.this.id
  name     = each.key
  #
  depends_on = [
    data.keycloak_realm.this
  ]
}

resource "keycloak_group_memberships" "group_memberships" {
  for_each = var.keycloak_group_memberships
  #
  realm_id = data.keycloak_realm.this.id
  group_id = keycloak_group.group[each.key].id
  #
  members = each.value
  #
  depends_on = [
    data.keycloak_realm.this,
    data.keycloak_user.user,
    keycloak_group.group
  ]
}
