module Nginx
  module Helper
    def bulk_install(packages)
      execute 'install packages in bulk' do
        command "apt-get -y install #{packages.join(' ')}"
      end
    end
  end
end
