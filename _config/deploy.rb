set :application, "gusg.us"
set :scm, :git
set :branch, "master"
set :deploy_via, :remote_cache
set :git_enable_submodules, 1
set :repository, "git@github.com:jaknowlden/gusgus.git"

set :deploy_to, "/var/app/#{application}"
set :user, "justin"
set :use_sudo, false
set :runner, nil

role :app, "gusg.us"
role :web, "gusg.us"
role :db,  "gusg.us", :primary => true

namespace :deploy do
  desc "Restart Application - doesn't do anything in our case :)"
  task :restart do
    puts "love."
  end
end
