# Sponsorly

[![Deploy to DO](https://mp-assets1.sfo2.digitaloceanspaces.com/deploy-to-do/do-btn-blue.svg)](https://cloud.digitalocean.com/apps/new?repo=https://github.com/AminArria/sponsorly/tree/main&refcode=17622c85e2ca)

## Requirements (versions used)

- PostgreSQL 12.3
- Elixir 1.11.2 OTP 22
- NPM 7.0.10

## Local Development

First fetch dependencies

```
  mix deps.get
```

Fetch NPM dependencies

```
  npm install --prefix assets/
```

For the database you can use `docker-compose` with our [docker-compose.yml](docker-compose.yml) file that sets it up. Otherwise you need to create a user named `sponsorly_user` with password `sponsorlydevelop`, give permission to create a database, and run `mix ecto.create`.

Then we have to run the migrations

```
  mix ecto.migrate
```

Last, we start our Phoenix server

```
  mix phx.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Deploying

For deployment we are using [releases](https://hexdocs.pm/phoenix/releases.html#content) in a [Dockerfile](Dockerfile).

Part of using releases is moving the configuration to [releases.exs](config/releases.exs) which runs on startup instead of compilations as the other configs. This allows us to have set everything at runtime and not worry about secrets leaking to the world (or at least not so easily).

The following are the **required** environment variables used in configuration:

- `DATABASE_URL`: URL to access your prod database
- `SECRET_KEY_BASE`: Secret key used by Phoenix, generate by doing `mix phx.gen.secret`
- `POSTMARK_API_KEY`: Postmark API key, only required if using Postmark for sending mails
- `USE_LOCAL_ADAPTER`: set to `"true"` to use `Bamboo.LocalAdapter` to send mails instead of Postmark, default `"false"`

The following are the **optional** environment variables used in configuration:

- `POOL_SIZE`: size of connections pool to database, default: `10`
- `PORT`: port used by Phoenix, default: `4000`

After making a deployment if you need to run migrations you can connect to the instance and use `Sponsorly.Release.migrate()`
