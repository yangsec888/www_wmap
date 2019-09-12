# References to construct the dockerfile:
# How to use Bundler with Docker: https://bundler.io/v2.0/guides/bundler_docker_guide.html
# Rails on Docker: https://thoughtbot.com/blog/rails-on-docker
# Docker on parallels tutorial: https://zitseng.com/archives/10861
# Docker on MariaDB: https://hub.docker.com/r/bitnami/mariadb/
# Compose and Rails: https://docs.docker.com/compose/rails/
FROM ruby:2.5.1
RUN apt-get update -qq && apt-get install -y build-essential

# for mysql
# RUN apt-get install -y mariadb-server mariadb-client
RUN apt-get install -y mariadb-client

# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

# for Redis
RUN apt-get install -y redis-server redis-tools
ADD config/redis.conf /usr/local/etc/redis/redis.conf

# for a JS runtime
RUN apt-get install -y nodejs

# for nginx
RUN apt-get install -y nginx

# for postfix
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install -yq postfix

# for app running directory setup
ENV APP_HOME /www_wmap
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# for building app runtime
ADD Gemfile* $APP_HOME/
ADD . $APP_HOME
RUN bundle install

# for sidekiq
ADD .env $APP_HOME/

# Add a script to be executed every time the container starts.
ENTRYPOINT ["sh","./config/docker/entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD config/docker/start.sh
