# frozen_string_literal: true

# Parse an ssh authorized_keys line string into an array using its expected
# pattern by using a combination of regex matching and extracting the substring
# before the match as ssh-options. This allows whitespaces inside the options
# and inside the comment and is consistent with the behavior of openssh.
# The returned options element can by an empty string.
Puppet::Functions.create_function(:accounts_ssh_authorized_keys_line_parser) do
  # @param str ssh authorized_keys line string
  # @return [Array] of authroized_keys_line components:
  #   ['options','keytype','key','comment']
  # @example Calling the function
  #   accounts_ssh_authorized_keys_line_parser_string('options ssh-rsa AAAA... comment)
  dispatch :accounts_ssh_authorized_keys_line_parser_string do
    param 'String', :str
  end

  def accounts_ssh_authorized_keys_line_parser_string(str)
    matched = str.match(%r{((sk-ssh-ed25519|sk-ecdsa-|ssh-|ecdsa-)[^\s]+)\s+([^\s]+)\s+(.*)$})
    raise ArgumentError, 'Wrong Keyline format!' unless matched && matched.length == 5
    options = str[0, str.index(matched[0])].rstrip
    [options, matched[1], matched[3], matched[4]]
  end
end
