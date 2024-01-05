FROM elixir:1.15

WORKDIR /app

RUN apt-get update && apt-get install -qy inotify-tools netcat wget mariadb-client iputils-ping

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force
#

# Install dependencies
COPY mix.exs mix.lock ./
COPY config config
COPY lib lib
COPY priv priv

RUN mix deps.get
RUN mix deps.compile
#RUN mix ecto.migrate

RUN mkdir -p /var/log/elixir_app

CMD ["mix", "run", "--no-halt"]
