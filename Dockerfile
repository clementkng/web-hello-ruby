FROM ruby:2.7-alpine

RUN bundle config --global frozen 1

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY ./webserver.rb /

WORKDIR /

CMD ruby webserver.rb
