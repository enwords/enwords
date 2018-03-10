ARG BASE_IMAGE=ruby:2.3.0-alpine

# We want to build from clean git tree, not current working directory
FROM ${BASE_IMAGE} as clean_checkout
RUN apk add git --no-cache
COPY . /source
RUN git clone /source /app
RUN rm -rf /app/.git

FROM ${BASE_IMAGE} as bundler_builder
RUN apk add build-base postgresql-dev git openssh-client libxml2-dev libxslt-dev --no-cache
ENV LANG C.UTF-8
WORKDIR /app
COPY --from=clean_checkout /app/Gemfile /app/Gemfile.lock ./
# RUN bundle config build.nokogiri --use-system-libraries
RUN bundle config build.nokogiri
RUN bundle install --deployment --without development test --jobs=3
RUN rm -rf ./vendor/bundle/ruby/*/cache/

FROM ${BASE_IMAGE} as app
ENV LANG C.UTF-8
RUN apk add libpq tzdata libxslt --no-cache
RUN cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime
WORKDIR /app
COPY --from=clean_checkout /app ./
COPY --from=bundler_builder /app/vendor ./vendor
COPY --from=bundler_builder /usr/local/bundle/config /usr/local/bundle/config
EXPOSE 3000
ENTRYPOINT ["bundle", "exec", "puma"]
