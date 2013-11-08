require 'rvm/capistrano'
require 'bundler/capistrano'

set :rvm_ruby_string, "2.0.0-p247" #tsb production
set :rvm_type, :system # rvm running as multi-user
set :rvm_path, '/usr/local/rvm' # as above, we're running multi-user rvm


 
set :application, "Moments"
set :repository,  "ssh://gitosis@205.186.148.27:40022/loopt.git"
set :port, "40022"
set :deploy_to, "/var/www/genapp.spa.me"

server "205.186.148.27", :app, :web, :db, :primary => true
set :user, "deployer"                             # The server's user for deploys
set :scm_passphrase, "rehj4w6i57iuyteg"           # The deploy user's password

ssh_options[:forward_agent] = true

set :scm, "git"
set :branch, "master"
set :deploy_via, :remote_cache
default_run_options[:pty] = true                  # Must be set for the password prompt from git to work

namespace :db do
  desc "Populates the Production Database"
   task :seed do
     puts "\n\n=== Populating the Production Database ===\n\n"
     run "cd #{current_path}; rake db:seed RAILS_ENV=production"
   end
   
  desc "Drops the Production Database"
    task :drop do
      puts "\n\n=== Dropping the Production Database ===\n\n"
      run "cd #{current_path}; rake db:drop RAILS_ENV=production"
  end
    
  desc "Migrates the Production Database"
    task :migrate do
      puts "\n\n=== Migrating the Production Database ===\n\n"
      run "cd #{current_path}; rake db:migrate RAILS_ENV=production"
  end
  
  desc "Rolls Back the Production Database"
    task :rollback do
      puts "\n\n===Rolling Back the Production Database ===\n\n"
      run "cd #{current_path}; rake db:rollback RAILS_ENV=production"
  end
end

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

end

namespace :deploy do
  # http://stackoverflow.com/questions/9016002/speed-up-assetsprecompile-with-rails-3-1-3-2-capistrano-deployment
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      from = source.next_revision(current_revision) rescue nil
      
      if from.nil? || capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end
end
# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end