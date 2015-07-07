#
class accounts::groups (
  $groups_hash
) {

  validate_hash($groups_hash)
  create_resources('group', $groups_hash)

}
