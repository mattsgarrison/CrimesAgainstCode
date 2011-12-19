$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"
set :rvm_ruby_string, 'ruby-1.9.3@global'

set :user, 'rails'
set :domain, 'crimesagainstcode.com'
set :applicationdir, "/home/rails/webapps/CrimesAgainstCode"
set :application, "CrimesAgainstCode.com"

set :repository,  "git@github.com:mattsgarrison/CrimesAgainstCode.git"
set :rails_env, "production"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :branch, "master"


set(:shared_config_path){"#{shared_path}/configs"}
set(:shared_database_path) {"#{shared_path}/databases"}
#ssh_options[:forward_agent] = true
#ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "rails_deploy_privatekey")]
role :web, domain                          # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run

# deploy config
set :deploy_to, applicationdir
set :deploy_via, :export

default_run_options[:pty] = true  # Forgo errors when deploying from windows
# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

#after :deploy, "deploy:migrate"

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :sqlite3 do
 
  desc "Links the configuration file"
  task :link_configuration_file, :roles => :db do
    run "ln -nsf #{shared_config_path}/sqlite_config.yml #{release_path}/config/database.yml"
  end
 
  desc "Make a shared database folder"
  task :make_shared_folder, :roles => :db do
    run "mkdir -p #{shared_database_path}"
  end
end


