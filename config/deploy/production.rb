set :stage, :production
server '78.155.219.83', user: 'deploy', roles: %w[web app db]
