Ohai.plugin(:NginxState) do
  provides 'nginx_state/compile_options'
  provides 'nginx_state/version'

  collect_data do
    nginx_state(Mash.new)

    command_result =
      shell_out('nginx -V 2>&1').stdout.split(/\n+/)

    if command_result[0].include?('command not found')
      nginx_state[:compile_options] = []
      nginx_state[:version] = 'None'
    else
      compile_options = command_result[4].split(' ')
      compile_options.shift(2)

      nginx_state[:compile_options] = compile_options

      nginx_state[:version] = command_result[0].split('/')[1]
    end
  end
end
