# References to construct the dockerfile:
# How to use Bundler with Docker: https://bundler.io/v2.0/guides/bundler_docker_guide.html
# Rails on Docker: https://thoughtbot.com/blog/rails-on-docker
# Docker on parallels tutorial: https://zitseng.com/archives/10861
# Docker on MariaDB: https://hub.docker.com/r/bitnami/mariadb/
# Compose and Rails: https://docs.docker.com/compose/rails/
# Dockerize a Rails 5 project example: https://nickjanetakis.com/blog/dockerize-a-rails-5-postgres-redis-sidekiq-action-cable-app-with-docker-compose
FROM ruby:2.6.3
RUN apt-get update -yqq && apt-get install -y build-essential \
  && apt-get install -y mariadb-client \
  && apt-get install -y libxml2-dev libxslt1-dev \
  && apt-get install -y redis-tools \
  && apt-get install -y nodejs

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
