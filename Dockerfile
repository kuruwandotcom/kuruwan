FROM ruby:3.0.0

RUN apt-get update && apt-get install -y --no-install-recommends vim

ENV APP_HOME=/home/app

ARG UID=1000
ARG GID=1000

RUN groupadd -r --gid ${GID} app \
 && useradd --system --create-home --home ${APP_HOME} --shell /sbin/nologin --no-log-init \
      --gid ${GID} --uid ${UID} app

WORKDIR $APP_HOME

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

USER app
COPY --chown=app:app . .

RUN gem install bundler
RUN bundle install

ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
