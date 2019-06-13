# config valid for current version and patch releases of Capistrano
lock '~> 3.11.0'

set :rvm_type, :user
set :rvm_ruby_string, 'ruby-2.5.3'

set :stages, %w(production staging development)
set :default_stage, 'staging'

domain = 'tbdmarket.com'
set :application, 'tbdmarket'
set :repo_url, 'git@github.com:briangan/solidus_market.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

base_path = '/var/www/solidus_market'
set :deploy_to, base_path

shared_path = base_path + '/shared'
current_path = base_path + '/current'
set :current_path, current_path

set :linked_files, %w{config/master.key}


######################################

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true


# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

set :user, 'deploy'
set :use_sudo, false

#######################################
# Puma server

set :puma_conf, "#{current_path}/config/puma.rb"
set :puma_bind,       "unix://#{shared_path}/sockets/puma.sock"
set :puma_state,      "#{shared_path}/pids/puma.state"
set :puma_pid,        "#{shared_path}/pids/puma.pid"
set :puma_access_log, "#{shared_path}/log/puma.error.log"
set :puma_error_log,  "#{shared_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, false  # Change to true if using ActiveRecord


#######################################
# Before and after

# after 'deploy', 'deploy:prepare_assets'

#######################################
# Extra actions

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/sockets -p"
      execute "mkdir #{shared_path}/pids -p"
      execute "mkdir #{shared_path}/log -p"
      execute "mkdir #{shared_path}/config -p"
    end
  end

  before :deploy, 'puma:make_dirs'.to_sym
end

namespace :deploy do
  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end
