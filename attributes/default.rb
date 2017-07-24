default['pcre']['version'] = '8.40'
default['zlib']['version'] = '1.2.11'
default['openssl']['version'] = '1.0.2f'

default['nginx']['git_branch'] = 'master'
default['nginx']['binary'] = '/usr/sbin/nginx'
default['nginx']['pid'] = '/etc/nginx/pid/nginx.pid'

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

default['nginx']['config_paths'] = '--sbin-path=/usr/sbin/nginx '\
  '--conf-path=/etc/nginx/config/nginx.conf '\
  '--lock-path=/etc/nginx/lock/nginx.lock --pid-path=/etc/nginx/pid/nginx.pid '\
  '--error-log-path=/etc/nginx/logs/error.log '\
  '--http-log-path=/etc/nginx/logs/access.log '\
  '--http-client-body-temp-path=/etc/nginx/cache/client '\
  '--http-proxy-temp-path=/etc/nginx/cache/proxy '\
  '--http-fastcgi-temp-path=/etc/nginx/cache/fastcgi '\
  '--http-uwsgi-temp-path=/etc/nginx/cache/uwsgi '\
  '--http-scgi-temp-path=/etc/nginx/cache/scgi'

default['nginx']['build_packages'] =
  %w( autoconf automake bc bison
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
      xtrans-dev zip zlib1g-dev zlibc sysstat auditd )
