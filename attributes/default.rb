default['pcre']['enabled'] = true
default['pcre']['version'] = '8.40'
default['pcre']['source_dir'] = '/src/pcre'
default['pcre']['source_url'] =
  'ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/'\
  "pcre-#{default['pcre']['version']}.tar.gz"

default['zlib']['enabled'] = true
default['zlib']['version'] = '1.2.11'
default['zlib']['source_dir'] = '/src/zlib'
default['zlib']['source_url'] =
  "http://zlib.net/zlib-#{default['zlib']['version']}.tar.gz"

default['openssl']['enabled'] = true
default['openssl']['version'] = '1.0.2f'
default['openssl']['source_dir'] = '/src/openssl'
default['openssl']['source_url'] =
  'http://www.openssl.org/source/'\
  "openssl-#{default['openssl']['version']}.tar.gz"

default['nginx']['git_source'] = true
default['nginx']['version'] = 'master'
default['nginx']['source_dir'] = '/src/nginx'
default['nginx']['source_url'] = 'https://github.com/nginx/nginx'

# default['nginx']['git_source'] = false
# default['nginx']['version'] = '1.12.0'
# default['nginx']['source_dir'] = '/src/nginx'
# default['nginx']['source_url'] = 'http://nginx.org/download/'\
#   "nginx-#{default['nginx']['version']}.tar.gz"

default['nginx']['binary'] = '/usr/sbin/nginx'
default['nginx']['pid'] = '/etc/nginx/pid/nginx.pid'
default['nginx']['access_log'] = '/etc/nginx/logs/access.log'
default['nginx']['error_log'] = '/etc/nginx/logs/error.log'
default['nginx']['conf'] = '/etc/nginx/config/nginx.conf'
default['nginx']['lock'] = '/etc/nginx/lock/nginx.lock'
default['nginx']['client_body_temp'] = '/etc/nginx/cache/client'
default['nginx']['proxy_temp'] = '/etc/nginx/cache/proxy'
default['nginx']['fastcgi_temp'] = '/etc/nginx/cache/fastcgi'
default['nginx']['uwsgi_temp'] = '/etc/nginx/cache/uwsgi'
default['nginx']['scgi_temp'] = '/etc/nginx/cache/scgi'

default['nginx']['extra_config_opts'] = '--with-http_ssl_module'

default['nginx']['dirs'] =
  %w( /etc/nginx/cache
      /etc/nginx/config
      /etc/nginx/lock
      /etc/nginx/pid
      /etc/nginx/logs
      /etc/nginx/cache/client
      /etc/nginx/cache/proxy
      /etc/nginx/cache/fastcgi
      /etc/nginx/cache/uwsgi
      /etc/nginx/cache/scgi )

default['nginx']['build_packages'] =
  %w( autoconf automake bc bison sysstat auditd
      build-essential ccache cmake curl dh-systemd flex gcc geoip-bin
      google-perftools g++ haveged icu-devtools letsencrypt libacl1-dev
      libbz2-dev libcap-ng-dev libcap-ng-utils libcurl4-openssl-dev
      libdmalloc-dev libenchant-dev libevent-dev libexpat1-dev
      libfontconfig1-dev libfreetype6-dev libgd-dev libgeoip-dev
      libghc-iconv-dev libgmp-dev libgoogle-perftools-dev libice-dev libice6
      libicu-dev libjbig-dev libjpeg-dev libjpeg-turbo8-dev libjpeg8-dev
      libluajit-5.1-2 libluajit-5.1-common libluajit-5.1-dev liblzma-dev
      libmhash-dev libmhash2 libmm-dev libncurses5-dev libnspr4-dev libpam0g-dev
      libpcre3 libpcre3-dev libperl-dev libpng-dev libpthread-stubs0-dev
      libreadline-dev libselinux1-dev libsm-dev libsm6 libssl-dev libtidy-dev
      libtiff5-dev libtiffxx5 libtool libunbound-dev libvpx-dev libvpx3
      libwebp-dev libx11-dev libxau-dev libxcb1-dev libxdmcp-dev libxml2-dev
      libxpm-dev libxslt1-dev libxt-dev libxt6 make nano perl pkg-config
      python-dev software-properties-common systemtap-sdt-dev unzip webp wget
      xtrans-dev zip zlib1g-dev zlibc )
