#
# Cookbook:: nginx-source
# Recipe:: default
#

::Chef::Recipe.send(:include, Nginx::Helper)

version = {
  pcre: node['pcre']['version'],
  zlib: node['zlib']['version'],
  openssl: node['openssl']['version']
}

src_dir = {
  pcre: '/src/pcre',
  zlib: '/src/zlib',
  openssl: '/src/openssl',
  nginx: '/src/nginx'
}

apt_update 'apt' do
  frequency 86_400
  action :periodic
end

bulk_install(node['nginx']['build_packages'])

source_package 'pcre' do
  source_url 'ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/'\
  "pcre-#{version[:pcre]}.tar.gz"

  source_dir src_dir[:pcre]
  verify_file node['nginx']['binary']
end

source_package 'zlib' do
  source_url "http://zlib.net/zlib-#{version[:zlib]}.tar.gz"
  source_dir src_dir[:zlib]
  verify_file node['nginx']['binary']
end

source_package 'openssl' do
  source_url "http://www.openssl.org/source/openssl-#{version[:openssl]}.tar.gz"
  source_dir src_dir[:openssl]
  config_opts './config'
  verify_file node['nginx']['binary']
end

node['nginx']['dirs'].each do |nginx_dir|
  directory nginx_dir do
    recursive true
  end
end

source_package 'nginx' do
  source_url 'https://github.com/nginx/nginx'
  source_dir src_dir[:nginx]
  verify_file node['nginx']['binary']
  git_source true
  git_branch node['nginx']['git_branch']

  config_opts "./auto/configure --with-pcre=#{src_dir[:pcre]} "\
  "--with-zlib=#{src_dir[:zlib]} --with-openssl=#{src_dir[:openssl]} "\
  "--with-http_ssl_module #{node['nginx']['config_paths']}"

  notifies :cleanup, 'source_package[pcre]'
  notifies :cleanup, 'source_package[zlib]'
  notifies :cleanup, 'source_package[openssl]'
  notifies :cleanup, 'source_package[nginx]'
end

# Add Nginx service file for systemd
systemd_service_file 'nginx' do
  action :add
end

# Ensure Nginx service is started and enabled
service 'nginx' do
  action [:start, :enable]
end
