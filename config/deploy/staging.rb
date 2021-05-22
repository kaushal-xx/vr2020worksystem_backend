set :stage, :production
set :branch, :staging

role :app, %w(ubuntu@3.142.14.125)
role :web, %w(ubuntu@3.142.14.125)
role :db, %w(ubuntu@3.142.14.125)

set :rails_env, "production"
set :puma_env, "production"
set :puma_config_file, "#{shared_path}/config/puma.rb"
set :puma_conf, "#{shared_path}/config/puma.rb"