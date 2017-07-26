#
# Cookbook:: nginx-source
# Spec:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'nginx-source::default' do
  context 'Ubuntu 16.04' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(
        platform: 'ubuntu', version: '16.04', step_into: ['source_package']
      )
      runner.converge(described_recipe)
    end

    context 'converges' do
      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end
    end

    context 'installs packages from source' do
      %w(pcre zlib openssl nginx).each do |pkg|
        it "installs #{pkg} from source" do
          expect(chef_run).to install_source_package(pkg)
        end
      end
    end

    context 'creates necessary files and directories' do
      context 'nginx.conf' do
        it 'creates nginx.conf file' do
          expect(chef_run).to create_template('/etc/nginx/config/nginx.conf')
            .with(source: 'nginx.conf.erb').with(user: 'nginx')
            .with(group: 'nginx').with(mode: '0640')
        end

        it 'restarts nginx service if nginx.conf file is changed' do
          resource = chef_run.template('/etc/nginx/config/nginx.conf')
          expect(resource).to notify('service[nginx]')
            .to(:restart)
        end
      end

      it 'creates the nginx.service file' do
        expect(chef_run).to create_systemd_service_template(
          '/lib/systemd/system/nginx.service'
        )
      end

      dir_list =
        %w( /etc/nginx/logs /etc/nginx/config /etc/nginx/lock
            /etc/nginx/cache/client /etc/nginx/cache/proxy
            /etc/nginx/cache/fastcgi /etc/nginx/cache/uwsgi
            /etc/nginx/cache/scgi )

      dir_list.each do |dir|
        it "creates the #{dir} directory" do
          expect(chef_run).to create_directory(dir).with(recursive: true)
        end
      end
    end

    context 'creates users and groups' do
      it 'creates the nginx group' do
        expect(chef_run).to create_group('nginx')
      end

      it 'creates the nginx user' do
        expect(chef_run).to create_user('nginx').with(group: 'nginx')
          .with(shell: '/bin/false').with(manage_home: false)
      end
    end

    context 'configures services' do
      it 'enables the nginx service' do
        expect(chef_run).to enable_service('nginx')
      end

      it 'starts the nginx service' do
        expect(chef_run).to start_service('nginx')
      end
    end
  end
end
