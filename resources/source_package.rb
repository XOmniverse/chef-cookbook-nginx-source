resource_name :source_package
property :source_url, String, name_property: true
property :config_opts, String, default: './configure'
property :source_dir, String, default: '/source_install'
property :git_source, default: false
property :git_branch, default: 'master'

action :install do
  package 'build-essential'

  execute 'pre_clean_up' do
    command "rm -rf #{new_resource.source_dir}"
  end

  directory new_resource.source_dir do
    recursive true
  end

  if new_resource.git_source
    git new_resource.source_dir do
      repository new_resource.source_url
      revision new_resource.git_branch
      action :sync
      notifies :run, 'execute[configure_file]', :immediately
    end
  else
    remote_file "#{new_resource.source_dir}/local.tar.gz" do
      source new_resource.source_url
      notifies :run, 'execute[extract_file]', :immediately
    end
  end

  execute 'extract_file' do
    command 'tar -zxf local.tar.gz --strip 1'
    cwd new_resource.source_dir
    action :nothing
    notifies :run, 'execute[configure_file]', :immediately
  end

  execute 'configure_file' do
    command new_resource.config_opts
    cwd new_resource.source_dir
    action :nothing
    notifies :run, 'execute[install_file]', :immediately
  end

  execute 'install_file' do
    command 'make && make install'
    cwd new_resource.source_dir
    action :nothing
  end
end

action :cleanup do
  execute 'clean_up' do
    command "rm -rf #{new_resource.source_dir}"
  end
end
