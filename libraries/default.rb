module Nginx
  # Modules to be used at the Recipe level
  module RecipeHelper
    def nginx_installed?
      ::File.exist?(node['nginx']['binary'])
    end

    def bulk_install(packages)
      execute 'install packages in bulk' do
        command "apt-get -y install #{packages.join(' ')}"
      end
    end
  end

  # Modules to be used at the Resource level
  module ResourceHelper
    def nginx_installed?
      ::File.exist?(node['nginx']['binary']).to_s
    end

    def nginx_generate_config
      config_opts = if node['nginx']['git_source']
                      './auto/configure '
                    else
                      './configure '
                    end

      config_opts += "--sbin-path=#{node['nginx']['binary']} "\
      "--conf-path=#{node['nginx']['conf']} "\
      "--lock-path=#{node['nginx']['lock']} "\
      "--pid-path=#{node['nginx']['pid']} "\
      "--error-log-path=#{node['nginx']['error_log']} "\
      "--http-log-path=#{node['nginx']['access_log']} "\
      "--http-client-body-temp-path=#{node['nginx']['client_body_temp']} "\
      "--http-proxy-temp-path=#{node['nginx']['proxy_temp']} "\
      "--http-fastcgi-temp-path=#{node['nginx']['fastcgi_temp']} "\
      "--http-uwsgi-temp-path=#{node['nginx']['uwsgi_temp']} "\
      "--http-scgi-temp-path=#{node['nginx']['scgi_temp']} "

      if node['pcre']['enabled']
        config_opts += "--with-pcre=#{node['pcre']['source_dir']} "
      end

      if node['zlib']['enabled']
        config_opts += "--with-zlib=#{node['zlib']['source_dir']} "
      end

      if node['openssl']['enabled']
        config_opts += "--with-openssl=#{node['openssl']['source_dir']} "
      end

      config_opts + node['nginx']['extra_config_opts']
    end
  end
end
