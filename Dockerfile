# from ruby MRI version 2.6:
FROM ruby:2.7.2

# set up contact person for our project
LABEL maintainer='martins.kruze@gmail.com'

# nodejs: NodeJS for Rails runtime
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

# yarn: Yarn for assets
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | \
  tee /etc/apt/sources.list.d/yarn.list

# update current list of package providers and install folowing linkux packages:
# nodejs: NodeJS for Rails runtime
# yarn: Yarn for assets
# imagemagick: Linux image manimulation toolkit
# remove all downloaded lists with rm -rf /var/lib/apt/lists/*
RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends nodejs yarn postgresql-client \
  && rm -rf /var/lib/apt/lists/*

# make application direcory and direcory to mount wkhtmltox bin files
RUN mkdir /rubybattle.com

# change working direcotry to it
WORKDIR /rubybattle.com

# copy Gemfile and Gemfile.lock to our working direcotory
COPY Gemfile* /rubybattle.com/

# install gems
RUN bundle install

# copy our project
COPY . /rubybattle.com

# script that removes tmp/pids/server.pid file if it exists (need ensure it is executable with chmod +x docker-entrypoint.sh)
ENTRYPOINT ["./docker-entrypoint.sh"]
