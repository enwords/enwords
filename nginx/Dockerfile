FROM nginx
RUN apt-get update -qq && apt-get -y install apache2-utils
RUN apt-get -y install software-properties-common
RUN apt-get -y install certbot
ENV RAILS_ROOT /root/enwords
WORKDIR $RAILS_ROOT
RUN mkdir log
COPY public public/
COPY nginx/nginx.conf /tmp/docker.nginx
RUN envsubst '$RAILS_ROOT' < /tmp/docker.nginx > /etc/nginx/conf.d/default.conf
EXPOSE 80 443
CMD [ "nginx", "-g", "daemon off;" ]
