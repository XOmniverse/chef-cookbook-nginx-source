require 'spec_helper'

context 'Ubuntu 16.04 (NginxState Ohai Plugin)' do
  describe_ohai_plugin :NginxState do
    let(:plugin_file) { 'files/default/nginx_module.rb' }

    sample_output =
      "nginx version: nginx/1.13.4\n"\
      "built by gcc 5.4.0 20160609 (Ubuntu 5.4.0-6ubuntu1~16.04.4)\n"\
      "built with OpenSSL 1.0.2l  25 May 2017\n"\
      "TLS SNI support enabled\n"\
      'configure arguments: --sbin-path=/usr/sbin/nginx '\
      '--conf-path=/etc/nginx/config/nginx.conf '\
      '--lock-path=/etc/nginx/lock/nginx.lock'

    test_command = 'nginx -V 2>&1'
    context 'nginx_state/compile_options' do
      it 'provides nginx_state/compile_options attribute' do
        expect(plugin).to provides_attribute('nginx_state/compile_options')
      end

      it 'retrieves the nginx compile options from the OS' do
        test_output = double('Test Command', stdout: sample_output)

        compile_result =
          ['--sbin-path=/usr/sbin/nginx',
           '--conf-path=/etc/nginx/config/nginx.conf',
           '--lock-path=/etc/nginx/lock/nginx.lock']

        allow(plugin).to receive(:shell_out).with(test_command)
          .and_return(test_output)

        expect(plugin_attribute('nginx_state/compile_options'))
          .to eq(compile_result)
      end
    end

    context 'nginx_state/version' do
      it 'provides nginx_state/version attribute' do
        expect(plugin).to provides_attribute('nginx_state/version')
      end

      it 'retrieves the nginx version from the OS' do
        test_output = double('Test Command', stdout: sample_output)

        version_result = '1.13.4'

        allow(plugin).to receive(:shell_out).with(test_command)
          .and_return(test_output)

        expect(plugin_attribute('nginx_state/version')).to eq(version_result)
      end
    end
  end
end
