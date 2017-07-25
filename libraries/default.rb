module Nginx
  # Helper modules for installing Nginx
  module Helper
    def nginx_binary_exist?
      ::File.exist?(node['nginx']['paths']['binary'])
    end

    def nginx_binary_not_exist?
      !nginx_binary_exist?
    end

    def nginx_binary_working?
      node['nginx_state']['version'] != 'None'
    end

    def nginx_binary_not_working?
      !nginx_binary_working?
    end

    def config_changed?
      expected_config = nginx_generate_config.split(' ')
      expected_config.shift

      expected_config != node['nginx_state']['compile_options']
    end

    def config_not_changed?
      !config_changed?
    end

    def nginx_correctly_installed?
      return false if nginx_binary_not_exist?
      return false if nginx_binary_not_working?
      return false if config_changed?

      true
    end

    def nginx_not_correctly_installed?
      !nginx_correctly_installed?
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
