# Parse an ssh authorized_keys option string into an array using its expected
# pattern which matches a crazy regex slightly modified from shellwords. The
# pattern should be a string.

Puppet::Functions.create_function(:accounts_ssh_options_parser) do
  dispatch :accounts_ssh_options_parser_string do
    param 'String', :str
  end

  def accounts_ssh_options_parser_string(str)
    words = []
    field = ''
    str.scan(%r{\G\,*(?>([^\,\\\'\"]+)|'([^\']*)'|("(?:[^\"\\]|\\.)*")|(\\.?)|(\S))(\,|\z)?}m) do |word, sq, dq, esc, garbage, sep|
      raise ArgumentError, "Unmatched double quote: #{str.inspect}" if garbage
      field << (word || sq || dq || esc.gsub(%r{\\(.)}, '\\1'))
      field.gsub(%r{\\=}, '\\=\"')
      if sep
        words << field
        field = ''
      end
    end
    words
  end
end
