file_list = %w( /usr/sbin/nginx
                /etc/nginx/pid/nginx.pid )

dir_list = %w( /etc/nginx/cache/client
               /etc/nginx/cache/client
               /etc/nginx/cache/proxy
               /etc/nginx/cache/fastcgi
               /etc/nginx/cache/uwsgi
               /etc/nginx/cache/scgi )

file_list.each do |filename|
  describe file(filename) do
    it { should exist }
  end
end

dir_list.each do |dirname|
  describe directory(dirname) do
    it { should exist }
  end
end

describe file('/etc/nginx/config/nginx.conf') do
  it { should exist }
  its('content') { should match 'user  nginx;' }
end

describe file('/lib/systemd/system/nginx.service') do
  it { should exist }
  its('content') { should match 'PIDFile=' }
end

describe user('nginx') do
  it { should exist }
  its('group') { should eq 'nginx' }
  its('shell') { should eq '/bin/false' }
end

describe package('curl') do
  it { should be_installed }
end

describe package('nginx') do
  it { should_not be_installed }
end

describe service('nginx') do
  it { should be_enabled }
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end

describe command('nginx -v 2>&1') do
  its('stdout') { should match 'nginx version:' }
end

describe command('nginx -V 2>&1') do
  its('stdout') do
    should match '--sbin-path=/usr/sbin/nginx '\
    '--conf-path=/etc/nginx/config/nginx.conf '\
    '--lock-path=/etc/nginx/lock/nginx.lock '\
    '--pid-path=/etc/nginx/pid/nginx.pid '\
    '--error-log-path=/etc/nginx/logs/error.log '\
    '--http-log-path=/etc/nginx/logs/access.log '\
    '--http-client-body-temp-path=/etc/nginx/cache/client '\
    '--http-proxy-temp-path=/etc/nginx/cache/proxy '\
    '--http-fastcgi-temp-path=/etc/nginx/cache/fastcgi '\
    '--http-uwsgi-temp-path=/etc/nginx/cache/uwsgi '\
    '--http-scgi-temp-path=/etc/nginx/cache/scgi '\
    '--with-pcre=/src/pcre-8.40 '\
    '--with-zlib=/src/zlib-1.2.11 '\
    '--with-openssl=/src/openssl-1.0.2l '\
    '--with-http_ssl_module'
  end
end

describe command('curl -I localhost') do
  its('stdout') { should match '200 OK' }
  its('stdout') { should match 'Server: nginx' }
end
