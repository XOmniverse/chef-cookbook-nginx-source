#
# Cookbook:: nginx-source
# Recipe:: default
#

::Chef::Recipe.send(:include, Nginx::Helper)
::Chef::Resource.send(:include, Nginx::Helper)

ohai_plugin 'nginx_module'

apt_update

if nginx_not_correctly_installed?
  remove_nginx
  bulk_install(node['nginx']['build_packages']['ubuntu'])
end

%w(pcre zlib openssl).each do |pkg|
  source_package pkg do
    source_url node[pkg]['source_url']
    source_dir node[pkg]['source_dir']
    config_opts node[pkg]['config_opts']

    only_if { node[pkg]['enabled'] }
    not_if { nginx_correctly_installed? }
  end
end

source_package 'nginx' do
  source_url node['nginx']['source_url']
  source_dir node['nginx']['source_dir']

  git_source node['nginx']['git_source']
  git_branch node['nginx']['version']

  config_opts nginx_generate_config

  not_if { nginx_correctly_installed? }
end

group node['nginx']['group']

user node['nginx']['user'] do
  group node['nginx']['group']
  comment node['nginx']['user_description']
  shell '/bin/false'
  manage_home false
end

nginx_dirs.each do |nginx_dir|
  directory nginx_dir do
    recursive true
  end
end

template node['nginx']['paths']['conf'] do
  source 'nginx.conf.erb'
  user node['nginx']['user']
  group node['nginx']['group']
  mode '0640'

  notifies :restart, 'service[nginx]'
end

systemd_service_template '/lib/systemd/system/nginx.service'

service 'nginx' do
  action [:start, :enable]
end
