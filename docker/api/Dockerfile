FROM ruby:2.7
ENV LANG C.UTF-8

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

ENV APP_ROOT /usr/src/hippoworks
WORKDIR $APP_ROOT

RUN gem install bundler

COPY Gemfile $APP_ROOT
COPY Gemfile.lock $APP_ROOT

RUN bundle install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]