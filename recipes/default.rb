#
# Cookbook:: nginx-source
# Recipe:: default
#

::Chef::Recipe.send(:include, Nginx::RecipeHelper)
::Chef::Resource.send(:include, Nginx::ResourceHelper)

apt_update

bulk_install(node['nginx']['build_packages']) unless nginx_installed?

%w(pcre zlib openssl).each do |pkg|
  source_package pkg do
    source_url node[pkg]['source_url']
    source_dir node[pkg]['source_dir']
    config_opts './config' if pkg == 'openssl'

    only_if node[pkg]['enabled'].to_s
    not_if nginx_installed?
  end
end

node['nginx']['dirs'].each do |nginx_dir|
  directory nginx_dir do
    recursive true
  end
end

source_package 'nginx' do
  source_url node['nginx']['source_url']
  source_dir node['nginx']['source_dir']

  git_source node['nginx']['git_source']
  git_branch node['nginx']['version']

  config_opts nginx_generate_config

  not_if nginx_installed?

  %w(pcre zlib openssl nginx).each do |pkg|
    notifies :cleanup, "source_package[#{pkg}]"
  end
end

# Add Nginx service file for systemd
systemd_service_file 'nginx' do
  action :add
end

# Ensure Nginx service is started and enabled
service 'nginx' do
  action [:start, :enable]
end
