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

set :linked_files, %w{config/database.yml config/config.yml config/secrets.yml}

set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads}

namespace :deploy do
  after :finishing, 'deploy:cleanup'
end

