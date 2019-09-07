FROM ruby:2.6.1

COPY . /app
WORKDIR /app
RUN apt-get update
RUN apt-get install -y nodejs
RUN gem install bundler
RUN bundle install
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
CMD ["dbmigrate"]
CMD ["web"]
