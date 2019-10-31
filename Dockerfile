FROM ruby:2.6-alpine
LABEL maintainer="Ryan Schlesinger <ryan@ryanschlesinger.com>"

RUN apk add --no-cache \
  ca-certificates \
  wget \
  openssl \
  bash \
  build-base

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ENV BUNDLER_VERSION 2.0.2
RUN gem install bundler -v ${BUNDLER_VERSION} -i /usr/local/lib/ruby/gems/$(ls /usr/local/lib/ruby/gems) --force

RUN addgroup -S jukebot && \
    adduser -S -G jukebot jukebot

WORKDIR /srv
RUN chown -R jukebot:jukebot /srv
USER jukebot

COPY Gemfile Gemfile.lock /srv/

RUN bundle install

COPY . /srv/

CMD ["ruby", "jukebot.rb"]
