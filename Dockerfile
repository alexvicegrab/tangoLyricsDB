FROM ruby:2.5.1

ARG app_path=/ttdb

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir $app_path
WORKDIR $app_path
COPY Gemfile $app_path/Gemfile
COPY Gemfile.lock $app_path/Gemfile.lock
RUN bundle install
COPY . $app_path

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
