require 'spec_helper'

describe 'nginx-source::default' do
  context 'Ubuntu 16.04 (systemd_service_template Custom Resource)' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(
        platform: 'ubuntu', version: '16.04',
        step_into: ['systemd_service_template']
      )
      runner.converge(described_recipe)
    end

    it 'creates the nginx.service file from a template' do
      expect(chef_run).to create_template('/lib/systemd/system/nginx.service')
    end

    it 'reloads the systemd daemon' do
      resource = chef_run.template('/lib/systemd/system/nginx.service')
      expect(resource).to notify('execute[reload_systemd]')
        .to(:run).immediately
    end
  end
end
