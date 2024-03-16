# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.3.0
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Throw-away build stage to reduce size of final image
FROM base as build

LABEL maintainer='martins.kruze@gmail.com'

RUN apt-get update -yqq && apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    less \
    libpq-dev \
    postgresql-client \
    libvips42 \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /seeker
WORKDIR /seeker
COPY Gemfile* /seeker/
RUN bundle install

COPY . /seeker

# Final stage for app image
FROM base

# Run and own only the runtime files as a non-root user for security
RUN useradd rails --create-home --shell /bin/bash
USER rails:rails

ENTRYPOINT ["./docker-entrypoint.sh"]
