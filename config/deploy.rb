# encoding: utf-8
# config valid only for Capistrano 3
lock '3.6.0'

set :application, "enwords"
set :repository,  "file:///home/sadedv/enwords"


set :deploy_via, :copy

dpath = "/home/hosting_sadedv/projects/enwords"

set :user, "hosting_sadedv"
set :use_sudo, false
set :deploy_to, dpath

set :scm, :git

role :web, "chromium.locum.ru"                          # Your HTTP server, Apache/etc
role :app, "chromium.locum.ru"                          # This may be the same as your `Web` server
role :db,  "chromium.locum.ru", :primary => true # This is where Rails migrations will run

after "deploy:update_code", :copy_database_config

task :copy_database_config, roles => :app do
  db_config = "#{shared_path}/database.yml"
  run "cp #{db_config} #{release_path}/config/database.yml"
end

set :unicorn_rails, "/var/lib/gems/1.8/bin/unicorn_rails"
set :unicorn_conf, "/etc/unicorn/enwords.sadedv.rb"
set :unicorn_pid, "/var/run/unicorn/enwords.sadedv.pid"

# - for unicorn - #
namespace :deploy do
  desc "Start application"
  task :start, :roles => :app do
    run "#{unicorn_rails} -Dc #{unicorn_conf}"
  end

  desc "Stop application"
  task :stop, :roles => :app do
    run "[ -f #{unicorn_pid} ] && kill -QUIT `cat #{unicorn_pid}`"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "[ -f #{unicorn_pid} ] && kill -USR2 `cat #{unicorn_pid}` || #{unicorn_rails} -Dc #{unicorn_conf}"
  end
end