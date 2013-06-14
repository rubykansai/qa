require "bundler/capistrano"

require "capistrano-rbenv"
set :rbenv_ruby_version, "2.0.0-p195"

set :application, "qa"
set :repository,  "git://github.com/rubykansai/qa.git"
set :scm, :git
set :deploy_to, "/var/local/webapps/qa-rails3/"

set :use_sudo, false
set(:ssh_options, {
      :user => "app",
#      :verbose => :debug,
})

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "okkez.net"
role :app, "okkez.net"
role :db,  "okkez.net", :primary => true


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

# https://github.com/sosedoff/capistrano-unicorn
require "capistrano-unicorn"
after 'deploy:restart', 'unicorn:reload'


namespace :deploy do
  task :symlink_database_config do
    run "ln -s #{shared_path}/system/database.yml #{release_path}/config/database.yml"
  end
end

after("deploy:update_code", "deploy:symlink_database_config")
