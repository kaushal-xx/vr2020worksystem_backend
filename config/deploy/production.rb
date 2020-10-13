set :stage, :production
set :branch, :master

role :app, %w(ubuntu@3.139.47.251)
role :web, %w(ubuntu@3.139.47.251)
role :db, %w(ubuntu@3.139.47.251)

set :rails_env, "production"
set :puma_env, "production"
set :puma_config_file, "#{shared_path}/config/puma.rb"
set :puma_conf, "#{shared_path}/config/puma.rb"