require 'rvm/capistrano'

# set :rvm_ruby_string, "1.9.3-p286" #Bear in mind mod_passenger will have been compiled by a specific version of ruby which it will *always* use, which may cause issues!
#set :rvm_ruby_string, "1.9.3p125"  #staging
set :rvm_ruby_string, "2.0.0p247" #local
set :rvm_type, :system # rvm running as multi-user
set :rvm_path, '/usr/local/rvm' # as above, we're running multi-user rvm

require 'bundler/capistrano'

# set :stages, %w(production stage)
# set :stages, %w(production)
# set :default_stage, "production"
# require 'capistrano/ext/multistage'

set :application, "MOMENTS"
set :repository,  "gitosis@205.186.148.27:moments.git"
set :port, "40022"
set :deploy_to, "/var/www/ga.spa.me"

server "205.186.148.27", :app, :web, :db, :primary => true
set :port, 40022
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

# namespace :deploy do
#   task :ln_assets do
#     run <<-CMD
#       rm -rf #{latest_release}/public/assets &&
#       mkdir -p #{shared_path}/assets &&
#       ln -s #{shared_path}/assets #{latest_release}/public/assets
#     CMD
#   end
# 
#   update_code
#   ln_assets
#   
#   run_locally "rake assets:precompile"
#   run_locally "cd public; tar -zcvf assets.tar.gz assets"
#   top.upload "public/assets.tar.gz", "#{shared_path}", :via => :scp
#   run "cd #{shared_path}; tar -zxvf assets.tar.gz"
#   run_locally "rm public/assets.tar.gz"
#   run_locally "rm -rf public/assets"
#   
#   create_symlink
#   restart
# end

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

# after "deploy:create_symlink", "deploy:restart_workers"
 
# Rake helper task.
# def run_remote_rake(rake_cmd)
#   rake_args = ENV['RAKE_ARGS'].to_s.split(',')
#   cmd = "cd #{fetch(:latest_release)} && #{fetch(:rake, "rake")} RAILS_ENV=#{fetch(:rails_env, "production")} #{rake_cmd}"
#   cmd += "['#{rake_args.join("','")}']" unless rake_args.empty?
#   run cmd
#   set :rakefile, nil if exists?(:rakefile)
# end
#  
# namespace :deploy do
#   desc "Restart Resque Workers"
#   task :restart_workers, :roles => :db do
#     run_remote_rake "resque:restart_workers"
#   end
# end