# 与CPU核数一致
workers 1

# 每个worker的最小和最大工作进程
threads 1, 6

preload_app!

app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"

# 默认为产品环境
rails_env = ENV['RAILS_ENV'] || "production"
environment rails_env

# 设置socket
bind "unix://#{shared_dir}/sockets/shuiguoshe.puma.sock"

# 日志
stdout_redirect "#{shared_dir}/log/shuiguoshe.puma.stdout.log", "#{shared_dir}/log/shuiguoshe.puma.stderr.log", true

# 设置主进程号以及状态位置
pidfile "#{shared_dir}/pids/shuiguoshe.puma.pid"
state_path "#{shared_dir}/pids/shuiguoshe.puma.pid"

activate_control_app

on_worder_boot do
  require "active_record"
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[rails_env])
end