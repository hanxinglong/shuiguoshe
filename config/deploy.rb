# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'shuiguoshe'
set :deploy_user, "deployer"

set :puma_threads, [4, 16]
set :puma_workers, 0

set :puma_bind,  "unix://#{shared_path}/tmp/sockets/puma.#{fetch(:application)}.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.#{fetch(:application)}.state"
set :puma_pid,   "#{shared_path}/tmp/pids/puma.#{fetch(:application)}.pid"

set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"

set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to true if using ActiveRecord

set :scm, :git
set :repo_url, "git@github.com:tomwey/#{fetch(:application)}.git"

set :rbenv_type, :user
set :rbenv_ruby, '2.0.0-p353'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}

set :keep_releases, 5

set :linked_files, %w{config/database.yml config/config.yml config/newrelic.yml config/rsa_private_key.txt}

set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads}

namespace :puma do
  desc '创建目录'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end
  
  before :start, :make_dirs
end

namespace :deploy do
  
  # %w[start stop restart].each do |command|
  #   desc "#{command} unicorn server"
  #   task command do
  #     on roles(:app), in: :sequence, wait: 1 do
  #       execute "/etc/init.d/unicorn_#{fetch(:application)} #{command}"
  #     end
  #   end
  # end
  
  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end
  
  desc 'Restart app'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end
  
  # before :starting, :check_revision
  # after  :finishing, :compile_assets
  
  # task :setup_config do
  #   put File.read("config/database.yml.example"), "#{shared_path}/config/database.yml"
  #   put File.read("config/config.yml.example"), "#{shared_path}/config/config.yml"
  # end
  
  after :finishing, 'deploy:cleanup'
  after :finishing, 'deploy:restart'
  
  # before 'deploy:check:linked_files', 'deploy:setup_config'
end

namespace :remote_rake do
  task :create do
    run "cd #{deploy_to}/current; RAILS_ENV=production bundle exec rake db:create"
  end
  task :migrate do
    run "cd #{deploy_to}/current; RAILS_ENV=production bundle exec rake db:migrate"
  end
  task :seed do
    run "cd #{deploy_to}/current; RAILS_ENV=production bundle exec rake db:seed"
  end
  task :drop do
    run "cd #{deploy_to}/current; RAILS_ENV=production bundle exec rake db:drop"
  end
end

