resource_name :systemd_service_file
property :target_file, String, name_property: true
property :source_file, String, default: ''

action :add do
  template "/lib/systemd/system/#{new_resource.target_file}.service" do
    if new_resource.source_file == ''
      source "#{new_resource.target_file}.service.erb"
    else
      source "#{new_resource.source_file}.service.erb"
    end

    notifies :run, 'execute[reload_systemd]', :immediately
  end

  execute 'reload_systemd' do
    command 'systemctl daemon-reload'
    action :nothing
  end
end

action :delete do
  service new_resource.target_file do
    action [:disable, :stop]
  end

  file "/lib/systemd/system/#{new_resource.target_file}.service" do
    action :delete
    notifies :run, 'execute[reload_systemd]', :immediately
  end

  execute 'reload_systemd' do
    command 'systemctl daemon-reload'
    action :nothing
  end
end
