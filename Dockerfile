FROM ruby:2.6.1

COPY . /app
WORKDIR /app
RUN apt-get update
RUN apt-get install -y nodejs
RUN gem install bundler
RUN gem install nokogiri -v '1.10.4'
RUN gem install nio4r -v '2.5.1'
RUN gem install websocket-driver -v '0.7.1'
RUN bundle install
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
CMD ["dbmigrate"]
CMD ["web"]
