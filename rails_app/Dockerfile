# Based on https://semaphoreci.com/community/tutorials/dockerizing-a-ruby-on-rails-application

FROM ruby:2.5.1-slim

ARG APP_PATH=/ttdb

# Install dependencies:
#   - build-essential: To ensure certain gems can be compiled
#   - git: To ensure we can download packages with Git
#   - nodejs: Compile assets
#   - libpq-dev: Communicate with postgres through the postgres gem
#   - postgresql-client: To talk directly to postgres
RUN apt-get update -qq && apt-get install -y build-essential git nodejs libpq-dev postgresql-client

# Create directory and set context to it
RUN mkdir $APP_PATH
WORKDIR $APP_PATH

# Ensure gems are cached and only get updated when they change. This will
# drastically increase build times when your gems do not change.
RUN gem install bundler -v "~>1.0"
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --without development test

# Copy in the application code from your work station at the current directory
# over to the working directory
COPY . .

# Provide dummy data to Rails so it can pre-compile assets.
RUN bundle exec rake RAILS_ENV=production SECRET_TOKEN=atoken assets:precompile

# Expose a volume so that nginx will be able to read in assets in production.
VOLUME ["$APP_PATH/public"]

# Start the main process.
CMD bundle exec unicorn -c config/unicorn.rb
