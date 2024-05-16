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
    param 'String[1]', :str
  end

  def accounts_ssh_authorized_keys_line_parser_string(str)
    matched = str.match(%r{((sk-ssh-ed25519|sk-ecdsa-|ssh-|ecdsa-)[^\s]+)\s+([^\s]+)\s+(.*)$})

    raise ArgumentError, "Wrong Keyline format! Got nil after applying regex to'#{str}'" unless matched
    unless matched.length == 5
      output = []
      # first element is str, aftwerwards are all matching groups. We ignore the first element
      (1..matched.length).each do |counter|
        output << "element #{counter}: #{matched[counter]}"
      end
      raise ArgumentError, "Wrong Keyline format! Input: #{str}. Expected 4 elements after applying regex, got: #{output}"
    end

    options = str[0, str.index(matched[0])].rstrip
    [options, matched[1], matched[3], matched[4]]
  end
end
