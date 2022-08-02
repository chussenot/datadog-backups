FROM ruby:2.7.1

ADD . .
RUN bundle install
CMD ./main --team all