FROM ruby:2.7.1
RUN apt-get update && apt-get -y install cron
WORKDIR /app
COPY . ./
RUN bundle install
RUN bundle exec whenever --update-crontab
EXPOSE 3000
