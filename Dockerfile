FROM hippware/alpine-elixir-dev:1.8

ENV REFRESHED_AT=2019-04-18 \
    MIX_ENV=prod

COPY mix.exs mix.lock version.exs ./

RUN mix do deps.get, deps.compile

COPY rel/ ./rel/
COPY config/ ./config/
COPY lib/ ./lib/

RUN mix release --warnings-as-errors --no-tar --quiet


FROM alpine:3.9

ENV LANG=en_US.UTF-8 \
    HOME=/opt/app \
    SHELL=/bin/sh \
    TERM=xterm \
    REPLACE_OS_VARS=true

RUN \
    mkdir -p ${HOME} && \
    mkdir -p ${HOME}/var/log && \
    adduser -s /bin/sh -u 1001 -G root -h ${HOME} -S -D default && \
    chown -R 1001:0 ${HOME} && \
    apk --no-cache upgrade && \
    apk add --no-cache \
      bash \
      ca-certificates \
      expat \
      libgcc \
      libstdc++ \
      ncurses \
      openssl \
      tcpdump \
      zlib && \
    chmod +s /usr/sbin/tcpdump && \
    update-ca-certificates --fresh

USER default
WORKDIR /opt/app

COPY --from=0 /opt/app/_build/prod/rel/dawdle_db_watcher ./

ENTRYPOINT ["bin/dawdle_db_watcher"]
CMD ["foreground"]
