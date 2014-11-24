worker_processes 6

root = "/home/deployer/apps/shuiguoshe_production/current"
working_directory root
# shared_root = "/home/deployer/apps/shuiguoshe/shared"

listen "/tmp/unicorn.shuiguoshe.sock", :backlog => 64
listen 4096, :tcp_nopush => false

timeout 30

pid "#{root}/tmp/pids/unicorn_shuiguoshe.pid"

stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

# listen "/tmp/unicorn.keke_official_website.sock"

