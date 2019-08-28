# Parse an ssh authorized_keys option hash into an array
Puppet::Functions.create_function(:accounts_ssh_options) do
  # @param {Hash} ssh authorized_keys option hash
  # @return String comma-separated options
  # @example Calling the function
  #   accounts_ssh_options_list()
  dispatch :accounts_ssh_options_list do
    param 'Array', :opts
  end

  def accounts_ssh_options_list(opts)
    options = []
    opts.each do |option|
      if option.respond_to?(:each)
        option.each do |k, v|
          if v.respond_to?(:join)
            vq = "\""+ v.join(',') +"\""
          else
            vq = "\""+ v +"\""
          end
          options << [k, vq].join('=')
        end
      else
        options << option
      end
    end
    options
  end
end
