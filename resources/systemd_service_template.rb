resource_name :systemd_service_template
property :template_name, String, name_property: true
property :source, String, default: ''

action :create do
  template new_resource.template_name do
    if new_resource.source == ''
      source "#{::File.basename(new_resource.template_name)}.erb"
    else
      source new_resource.source
    end

    notifies :run, 'execute[reload_systemd]', :immediately
  end

  execute 'reload_systemd' do
    command 'systemctl daemon-reload'
    action :nothing
  end
end

action :delete do
  service ::File.basename(new_resource.template_name) do
    action [:disable, :stop]
  end

  file new_resource.template_name do
    action :delete
    notifies :run, 'execute[reload_systemd]', :immediately
  end

  execute 'reload_systemd' do
    command 'systemctl daemon-reload'
    action :nothing
  end
end
