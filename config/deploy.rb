# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'shuiguoshe'
set :deploy_user, "deployer"

set :scm, :git
set :repo_url, "git@github.com:tomwey/#{fetch(:application)}.git"

set :rbenv_type, :user
set :rbenv_ruby, '2.0.0-p353'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}

set :keep_releases, 5

set :linked_files, %w{config/database.yml config/config.yml}

set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads}

namespace :deploy do
  
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command do
      on roles(:app), in: :sequence, wait: 1 do
        execute "/etc/init.d/unicorn_#{fetch(:application)} #{command}"
      end
    end
  end
  
  # task :setup_config do
  #   put File.read("config/database.yml.example"), "#{shared_path}/config/database.yml"
  #   put File.read("config/config.yml.example"), "#{shared_path}/config/config.yml"
  # end
  
  after :finishing, 'deploy:cleanup'
  after :finishing, 'deploy:restart'
  
  # before 'deploy:check:linked_files', 'deploy:setup_config'
end

