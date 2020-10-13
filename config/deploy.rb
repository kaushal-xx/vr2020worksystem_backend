# config valid for current version and patch releases of Capistrano
lock "~> 3.14.1"

set :application, "vr2020worksystem_backend"
set :repo_url, "git@github.com:kaushal-xx/vr2020worksystem_backend.git"

set :user,            'ubuntu'
set :puma_threads,    [4, 16]
set :puma_workers,    0

# Don't change these unless you know what you're doing
set :user, "root"
set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/ubuntu/vr2020worksystem_backend"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :ssh_options,     forward_agent: true, user: fetch(:user), keys: %w[~/.ssh/id_rsa.pub]
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true # Change to false when not using ActiveRecord
set :rvm_ruby_string, 'ruby-2.5.7@vr2020worksystem_backend'
# set :sidekiq_config, -> { File.join(shared_path, 'config', 'sidekiq.yml') }
# set :sidekiq_cmd, "#{fetch(:bundle_cmd, 'bundle')} exec sidekiq -d  -L log/sidekiq.log -c 5"

## Defaults:

# set :scm,           :git

# set :branch,        :master

# set :format,        :pretty

# set :log_level,     :debug

# set :keep_releases, 5

## Linked Files & Directories (Default None):

set :linked_files, %w[config/database.yml config/secrets.yml .env config/master.key]
set :linked_dirs,  %w[log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system certificates]

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  desc 'Restart application'
  task :start do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:start'
    end
  end
  # before :start, :make_dirs
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

  # after  :finishing, :compile_assets
  # after  :finishing, :cleanups
  after  :finishing, :restart
end

# ps aux | grep puma    # Get puma pid

# kill -s SIGUSR2 pid   # Restart puma

# kill -s SIGTERM pid   # Stop puma
