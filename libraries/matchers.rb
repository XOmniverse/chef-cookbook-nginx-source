if defined?(ChefSpec)
  ChefSpec.define_matcher(:source_package)

  def install_source_package(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:source_package, :install, resource)
  end

  def cleanup_source_package(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:source_package, :cleanup, resource)
  end

  ChefSpec.define_matcher(:systemd_service_template)

  def create_systemd_service_template(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:source_package, :create, resource)
  end

  def delete_systemd_service_template(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:source_package, :delete, resource)
  end
end
