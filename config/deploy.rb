lock '3.6.1'

set :application, 'enwords'
set :repo_url, 'git@github.com:enwords/enwords.git'

set :deploy_to, '/home/deploy/enwords'

set :linked_files, %w[config/application.yml]
set :linked_dirs, %w[log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system]

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :updated, 'deploy:migrate'
  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end
