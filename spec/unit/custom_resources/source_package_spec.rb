require 'spec_helper'

describe 'nginx-source::default' do
  context 'Ubuntu 16.04 (source_package Custom Resource)' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(
        platform: 'ubuntu', version: '16.04', step_into: ['source_package']
      )
      runner.converge(described_recipe)
    end

    context 'installs packages from source' do
      %w(pcre zlib openssl nginx).each do |pkg|
        context "installs #{pkg}" do
          it 'cleans up old source code' do
            expect(chef_run).to run_execute('pre_clean_up')
          end

          source_dir = '/src/pcre-8.40' if pkg == 'pcre'
          source_dir = '/src/zlib-1.2.11' if pkg == 'zlib'
          source_dir = '/src/openssl-1.0.2l' if pkg == 'openssl'
          source_dir = '/src/nginx-master' if pkg == 'nginx'

          it "creates #{source_dir} directory to store source code" do
            expect(chef_run).to create_directory(source_dir)
          end

          if pkg == 'nginx'
            it 'downloads nginx source from git repository' do
              expect(chef_run).to sync_git(source_dir)
            end

            it 'configures the nginx source in preparation for compiling' do
              resource = chef_run.git(source_dir)
              expect(resource).to notify('execute[configure_file]')
                .to(:run).immediately
            end
          else
            it "downloads #{pkg} source code tar.gz package" do
              expect(chef_run)
                .to create_remote_file("#{source_dir}/local.tar.gz")
            end

            it 'extracts the source code from the tar.gz package' do
              resource = chef_run.remote_file("#{source_dir}/local.tar.gz")
              expect(resource).to notify('execute[extract_file]')
                .to(:run).immediately
            end

            it 'configures the source in preparation for compiling' do
              resource = chef_run.execute('extract_file')
              expect(resource).to notify('execute[configure_file]')
                .to(:run).immediately
            end
          end

          it "compiles and installs #{pkg} from source" do
            resource = chef_run.execute('configure_file')
            expect(resource).to notify('execute[install_file]')
              .to(:run).immediately
          end
        end
      end
    end
  end
end
