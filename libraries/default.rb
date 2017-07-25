module Nginx
  # Helper modules for installing Nginx
  module Helper
    def installed?(pkg)
      installed = false

      case pkg
      when 'nginx'
        installed = true unless node['nginx_state']['version'] == 'None'
      when 'pcre'
        installed = node['nginx_state']['compile_options'].include?(
          "--with-pcre=#{node['pcre']['source_dir']}"
        )
      when 'zlib'
        installed = node['nginx_state']['compile_options'].include?(
          "--with-zlib=#{node['zlib']['source_dir']}"
        )
      when 'openssl'
        installed = node['nginx_state']['compile_options'].include?(
          "--with-openssl=#{node['openssl']['source_dir']}"
        )
      end

      installed
    end

    def not_installed?(pkg)
      !installed?(pkg)
    end

    def modules_changed?
      changed = false

      changed = true if installed?('pcre') != node['pcre']['enabled']
      changed = true if installed?('zlib') != node['zlib']['enabled']
      changed = true if installed?('openssl') != node['openssl']['enabled']

      changed
    end

    def modules_not_changed?
      !modules_changed?
    end

    def correctly_installed?
      correctly = true

      correctly = false if modules_changed?
      correctly = false if not_installed?('nginx')

      correctly
    end

    def not_correctly_installed?
      !correctly_installed?
    end

    def remove_nginx
      service 'nginx' do
        action :stop
        ignore_failure true
      end

      execute 'delete_nginx_binary' do
        command "rm -f #{node['nginx']['paths']['binary']}"
        ignore_failure true
      end
    end

    def nginx_dirs
      dir_list = []

      dir_list.push ::File.dirname(node['nginx']['paths']['binary'])
      dir_list.push ::File.dirname(node['nginx']['paths']['pid'])
      dir_list.push ::File.dirname(node['nginx']['paths']['access_log'])
      dir_list.push ::File.dirname(node['nginx']['paths']['error_log'])
      dir_list.push ::File.dirname(node['nginx']['paths']['conf'])
      dir_list.push ::File.dirname(node['nginx']['paths']['lock'])

      dir_list.push node['nginx']['paths']['client_body_temp']
      dir_list.push node['nginx']['paths']['proxy_temp']
      dir_list.push node['nginx']['paths']['fastcgi_temp']
      dir_list.push node['nginx']['paths']['uwsgi_temp']
      dir_list.push node['nginx']['paths']['scgi_temp']

      dir_list.uniq
    end

    def bulk_install(packages)
      execute 'install packages in bulk' do
        command "apt-get -y install #{packages.join(' ')}"
      end
    end

    def nginx_generate_config
      config_opts = if node['nginx']['git_source']
                      './auto/configure '
                    else
                      './configure '
                    end

      config_opts += "--sbin-path=#{node['nginx']['paths']['binary']} "\
      "--conf-path=#{node['nginx']['paths']['conf']} "\
      "--lock-path=#{node['nginx']['paths']['lock']} "\
      "--pid-path=#{node['nginx']['paths']['pid']} "\
      "--error-log-path=#{node['nginx']['paths']['error_log']} "\
      "--http-log-path=#{node['nginx']['paths']['access_log']} "\
      '--http-client-body-temp-path='\
        "#{node['nginx']['paths']['client_body_temp']} "\
      "--http-proxy-temp-path=#{node['nginx']['paths']['proxy_temp']} "\
      "--http-fastcgi-temp-path=#{node['nginx']['paths']['fastcgi_temp']} "\
      "--http-uwsgi-temp-path=#{node['nginx']['paths']['uwsgi_temp']} "\
      "--http-scgi-temp-path=#{node['nginx']['paths']['scgi_temp']} "

      if node['pcre']['enabled']
        config_opts += "--with-pcre=#{node['pcre']['source_dir']} "
      end

      if node['zlib']['enabled']
        config_opts += "--with-zlib=#{node['zlib']['source_dir']} "
      end

      if node['openssl']['enabled']
        config_opts += "--with-openssl=#{node['openssl']['source_dir']} "\
                       '--with-http_ssl_module '
      end

      config_opts + node['nginx']['extra_config_opts']
    end
  end
end
