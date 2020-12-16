# frozen_string_literal: true

# Parse an ssh authorized_keys option string into an array using its expected pattern which matches a crazy regex slightly modified
# from shell words. The pattern should be a string.
Puppet::Functions.create_function(:accounts_ssh_options_parser) do
  # @param str ssh authorized_keys option string
  # @return [Array] Separated components of the string
  # @example Calling the function
  #   accounts_ssh_option_parser_string()
  dispatch :accounts_ssh_options_parser_string do
    param 'String', :str
  end

  def accounts_ssh_options_parser_string(str)
    words = []
    field = ''
    str.scan(%r{\G\,*(?>([^\,\\\'\"]+)|'([^\']*)'|("(?:[^\"\\]|\\.)*")|(\\.?)|(\S))(\,|\z)?}m) do |word, sq, dq, esc, garbage, sep|
      raise ArgumentError, _('Unmatched double quote: %{str_inspect}') % { str_inspect: str.inspect } if garbage

      field += (word || sq || dq || esc.gsub(%r{\\(.)}, '\\1'))
      field.gsub(%r{\\=}, '\\=\"')
      if sep
        words << field
        field = ''
      end
    end
    words
  end
end
