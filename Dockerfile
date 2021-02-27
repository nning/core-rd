FROM ruby:2.6

ADD . /app
WORKDIR /app
RUN bundle

CMD rackup