FROM ruby:3.1.0
WORKDIR /usr/src/app
RUN bundle config --global frozen 1
COPY Gemfile Gemfile.lock ./
RUN bundle check || bundle install
COPY . .
