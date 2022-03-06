FROM ruby:3.0
ENV LANG C.UTF-8

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs 

ENV APP_ROOT /usr/src/app
WORKDIR $APP_ROOT

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs

RUN apt-get update && apt-get install yarn -y

# ADD ./web/api/Gemfile $APP_ROOT
# ADD ./web/api/Gemfile.lock $APP_ROOT

# RUN bundle install

# ADD ./web/api $APP_ROOT