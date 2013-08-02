#set :application, "set your application name here"
#set :repository,  "set your repository location here"
#
## set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
## Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
#
#role :web, "your web-server here"                          # Your HTTP server, Apache/etc
#role :app, "your app-server here"                          # This may be the same as your `Web` server
#role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"
#
## if you want to clean up old releases on each deploy uncomment this:
## after "deploy:restart", "deploy:cleanup"
#
## if you're still using the script/reaper helper you will need
## these http://github.com/rails/irs_process_scripts
#
## If you are using Passenger mod_rails uncomment this:
## namespace :deploy do
##   task :start do ; end
##   task :stop do ; end
##   task :restart, :roles => :app, :except => { :no_release => true } do
##     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
##   end
## end
#

#require "rvm/capistrano"
#
#set :using_rvm, true
#set :rvm_ruby_string, 'ruby-1.9.2@kmvjobs'

set :application, "TicketManager"
set :repository,  "https://github.com/Shooshpanius/ticket"

set :scm, "git"
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :user, 'root' # пользователь удалённого сервера
set :use_sudo, false # не запускать команды под sudo

set :deploy_to, "/home/zaitsev/www/TicketManager"
server "192.168.0.204", :app, :web, :db, :primary => true

set :keep_releases, 5
set :deploy_via, :remote_cache

set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/tmp/unicorn.pid"
set :rails_env, "production"

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
    # run "cp #{current_release} #{deploy_to}/current"
  end

  task :stop, :roles => :app do

  end

  desc "Update Bundles"
  task :bundles, :roles => :app do
    run "cd #{deploy_to}/current &&  bundle install --without test development win"
  end

  desc "Db Migrate"
  task :migrate, :roles => :app do
    run "cd #{deploy_to}/current &&  rake environment RAILS_ENV=production db:migrate"
  end

  desc "Sitemap Gen"
  task :refresh_sitemaps , :roles => :app do
    run "cd #{deploy_to}/current && rake environment RAILS_ENV=production sitemap:refresh"
  end

  desc "Clear DB"
  task :clear_db , :roles => :app do
    #run "cd #{deploy_to}/current && rake environment RAILS_ENV=production clear_db:vacancy"
  end


  task :precompile_assets, :roles => :app do
    run "cd #{deploy_to}/current && RAILS_ENV=production rake assets:precompile"
  end

  #namespace :thin do
  #  task :start do
  #    run "cd #{deploy_to}/current && thin start -s3 --socket /tmp/thin.sock -e production"
  #  end
  #
  #  task :stop do
  #    run "cd #{deploy_to}/current && thin stop -s3 --socket /tmp/thin.sock -e production"
  #  end
  #
  #  task :restart do
  #    run "cd #{deploy_to}/current && thin restart -s3 --socket /tmp/thin.sock -e production"
  #  end
  #end


  namespace :thin do
    task :restart do
      run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D; fi"
    end
    task :start do
      run "bundle exec unicorn_rails -c #{unicorn_conf} -E #{rails_env} -D"
    end
    task :stop do
      run "if [ -f #{unicorn_pid} ] && [ -e /proc/$(cat #{unicorn_pid}) ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
    end
  end


  #namespace :thin do
  #  task :start do
  #    run "cd #{deploy_to}/current && thin start -s3 --socket /tmp/thin.sock -e production"
  #  end
  #
  #  task :stop do
  #    run "cd #{deploy_to}/current && thin stop -s3 --socket /tmp/thin.sock -e production"
  #  end
  #
  #  task :restart do
  #    run "cd #{deploy_to}/current && thin restart -s3 --socket /tmp/thin.sock -e production"
  #  end
  #end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  desc "Regenerate css with Sass and package assets with Jammit"
  task :package_assets, :roles => :app do
    # Add `gem 'sass'` in your gemfile.rb if no task sass:update
    # run "RAILS_ENV=production cd #{deploy_to}/current && rake sass:update && jammit"
  end
end

after "deploy:update", "deploy:cleanup", "deploy:bundles", "deploy:migrate", "deploy:thin:restart", "deploy:clear_db", "deploy:refresh_sitemaps", "deploy:precompile_assets"
before "deploy:restart", "deploy:package_assets"

