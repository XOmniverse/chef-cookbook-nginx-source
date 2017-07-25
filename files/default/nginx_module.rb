Ohai.plugin(:NginxState) do
  provides 'nginx_state/compile_options'
  provides 'nginx_state/version'

  collect_data do
    nginx_state(Mash.new)

    result = shell_out('nginx -V 2>&1 | grep configure | cut -f3-999 -d" "')
    nginx_state[:compile_options] = result.stdout.split(' ')

    result = shell_out('nginx -v 2>&1 | cut -f3 -d" " | cut -f2 -d"/"')

    nginx_state[:version] = if result.stdout.contains?('command')
                              'None'
                            else
                              result.stdout
                            end
  end
end
