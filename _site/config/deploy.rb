set :application, "gusg.us"
set :scm, :git
set :branch, "master"
set :deploy_via, :remote_cache
set :git_enable_submodules, 1
set :repository, "git@github.com:jaknowlden/gusgus.git"

set :deploy_to, "/home/justin/#{application}"
set :user, "justin"
set :use_sudo, false
set :runner, nil

role :app, "gusg.us"
role :web, "gusg.us"
role :db,  "gusg.us", :primary => true

namespace :deploy do
  desc "Restart Application"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
    puts "love."
  end
end

set :cold_deploy, false
before("deploy:cold") { set :cold_deploy, true }
