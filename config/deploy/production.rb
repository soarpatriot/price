set :stage, :local
set :server_name, "10.230.3.181"

# set :repo_url, 'git@git.rfdoa.cn:java/price.git'
set :branch, "master"

set :log_level, :debug
set :deploy_to, "/data/www/price"

set :use_sudo, true
set :thin_config, "#{shared_path}/config/thin.yml"
set :thin_pid, "#{shared_path}/tmp/pids/thin.0.pid"

set :ssh_option,{
  keys: %w(/home/liuhaibao/.ssh/id_rsa),
  forward_agent: true
}
# set :password, ask('Server password', nil)
# server fetch(:server_name), user: 'deploy', port: 22, password: fetch(:password), roles: %w{web app db}

server fetch(:server_name), user: "deploy", roles: %w{web app db}


