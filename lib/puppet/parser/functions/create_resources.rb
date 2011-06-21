Puppet::Parser::Functions::newfunction(:create_resources, :doc => '
Converts a hash into resources and adds them to the catalog.
Takes two parameters:
  create_resource($type, $resources)
    Creates resources of type $type from the $resources hash. Assumes that
    hash is in the following form:
     {title=>{attr=>value}}
') do |args|
  raise ArgumentError, 'requires resource type and param hash' if args.size < 2
  args[1].each do |title, params|
    # TODO - add argument to specify constraints on parameters
    raise ArgumentError, 'params should not contain title' if(params['title'])
    if type = Puppet::Type.type(args[0].to_sym)
      resource = type.hash2resource(params.merge(:title => title))
      catalog.add_resource(resource)
    elsif args[0].downcase == 'class'# || args[0].downcase == 'node'
      klass = find_hostclass(title)
      klass.ensure_in_catalog(self, params)
      compiler.catalog.add_class([title])
    else
      # TODO - use ensure_in_catalog when it supports definitions 
      # we assume that if nothing else mathces is must be a defined resource type
      resource = find_definition(args[0])
      p_resource = Puppet::Parser::Resource.new(args[0], title, :scope => self, :source => resource)
      params.merge(:name => title).each do |k,v|
        p_resource.set_parameter(k,v)
      end
      resource.instantiate_resource(self, p_resource)
      compiler.add_resource(self, p_resource)
    end
  end
end
