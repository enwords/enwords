#!/bin/bash
set -e

cd /app
if [[ "$1" = 'dbmigrate' ]]; then
    bundle exec rake db:migrate
fi
if [[ "$1" = 'web' ]]; then
    bundle exec rake assets:precompile
    bundle exec puma -C config/puma.rb
fi
if [[ "$1" = 'sidekiq' ]]; then
    bundle exec sidekiq
fi
if [[ -z "$1" ]]; then
    echo "No args. ($@)"
    exit 1
fi
