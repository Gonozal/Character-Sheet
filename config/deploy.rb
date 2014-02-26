require 'bundler/capistrano'

# Has to be configured before require.. weird capistrano
set :rvm_ruby_string, :local               # use the same ruby as used locally for deployment
set :rvm_autolibs_flag, "read-only"        # more info: rvm help autolibs

before 'deploy:setup', 'rvm:install_rvm'   # install RVM
before 'deploy:setup', 'rvm:install_ruby'  # install Ruby and create gemset, OR:
before 'deploy:setup', 'rvm:create_gemset' # only create gemset

require "rvm/capistrano"

#========================
#CONFIG
#========================
set :application, "character_sheet"
set :scm, :git
set :repository, "git@github.com:Gonozal/Character-Sheet.git"
set :branch, "master"
set :ssh_options, { :forward_agent => true }
set :stage, :production
set :user, "rails"
set :use_sudo, false
set :runner, "rails"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :remote_cache
set :app_server, :puma
set :domain, "chars4e.eu"
set :normalize_asset_timestamps, false
default_run_options[:pty]   = true
#========================
#ROLES
#========================
role :app, domain
role :web, domain
role :db, domain, :primary => true
#========================
#CUSTOM
#========================
namespace :puma do
  desc "Start Puma"
  task :start, :except => { :no_release => true } do
    run "#{sudo} start puma app=#{deploy_to}/current"
  end
  after "deploy:start", "puma:start"

  desc "Stop Puma"
  task :stop, :except => { :no_release => true } do
    run "#{sudo} start puma app=#{deploy_to}/current"
  end
  after "deploy:stop", "puma:stop"

  desc "Restart Puma"
  task :restart, roles: :app do
    run "#{sudo} stop puma app=#{deploy_to}/current"
    run "#{sudo} start puma app=#{deploy_to}/current"
  end
  after "deploy:restart", "puma:restart"

  desc "create a shared tmp dir for puma state files"
  task :after_symlink, roles: :app do
    run "rm -rf #{release_path}/tmp"
    run "ln -s #{shared_path}/tmp #{release_path}/tmp"
  end
  after "deploy:create_symlink", "puma:after_symlink"

  desc "create needed shared folders"
  task :setup_puma_folder, roles: :app do
    run "mkdir -p #{shared_path}/tmp"
    run "mkdir -p #{shared_path}/tmp/puma"
  end
  after "deploy:setup", "puma:setup_puma_folder"

end

############################
# Databse yml file linking #
namespace :deploy do
  desc "Symlink config files to their destination"
  task :setup_config, roles: :app do
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    put File.read("config/secret_token.example.rb"), "#{shared_path}/config/secret_token.rb"
    puts "Now edit the config files in #{shared_path}/config."
  end
  after "deploy:setup", "deploy:setup_config"

  desc "Seed the database"
  task :seed do
    run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end

  desc "Symlink database.yml config file to a shared path"
  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/secret_token.rb #{release_path}/config/initializers/secret_token.rb"
  end
  after "deploy:finalize_update", "deploy:symlink_config"
  after "deploy:update_code", "deploy:migrate"
end

# / Databse yml file linking #
##############################


