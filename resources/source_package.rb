resource_name :source_package
property :source_url, String, name_property: true
property :config_opts, String, default: './configure'
property :source_dir, String, default: '/source_install'
property :verify_file, String, required: true
property :git_source, default: false
property :git_branch, default: 'master'

action :install do
  unless ::File.exist?(verify_file)
    package 'build-essential'

    directory source_dir do
      recursive true
    end

    execute 'pre_clean_up' do
      command "rm -rf #{source_dir}/*"
    end

    if git_source
      git source_dir do
        repository source_url
        revision git_branch
        action :sync
        notifies :run, 'execute[configure_file]', :immediately
      end
    else
      remote_file "#{source_dir}/local.tar.gz" do
        source source_url
        notifies :run, 'execute[extract_file]', :immediately
      end
    end

    execute 'extract_file' do
      command 'tar -zxf local.tar.gz --strip 1'
      cwd source_dir
      action :nothing
      notifies :run, 'execute[configure_file]', :immediately
    end

    execute 'configure_file' do
      command config_opts
      cwd source_dir
      action :nothing
      notifies :run, 'execute[install_file]', :immediately
    end

    execute 'install_file' do
      command 'make && make install'
      cwd source_dir
      action :nothing
    end
  end
end

action :cleanup do
  execute 'clean_up' do
    command "rm -rf #{source_dir}"
  end
end
