# Socketything Presence

Socketything is a small Phoenix Presence server. Clients connect to `/socket`,
join a `presence:<page>` channel, and exchange normalized cursor coordinates.

To run it locally:

```sh
mix setup
mix phx.server
```

`GET /` is a minimal deployment health check. There is no browser UI, LiveView,
mailer, database, or static asset pipeline.

## Single-file Linux executable

Install Zig 0.15.2, then build the Burrito executable:

```sh
MIX_ENV=prod mix burrito.build
```

The executable is written to `burrito_out/socketything_linux_x86_64`. Run it
with a production secret and optional host and port:

```sh
SECRET_KEY_BASE="$(mix phx.gen.secret)" PHX_HOST=localhost PORT=4000 \
  ./burrito_out/socketything_linux_x86_64
```

Pushing a version tag builds the executable and publishes it with a checksum
on the corresponding GitHub Release:

```sh
git tag v0.1.0
git push origin v0.1.0
```
