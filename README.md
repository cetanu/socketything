# Socketything

To start your Phoenix server:

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

This application has no database layer. It does not require Ecto, PostgreSQL,
`DATABASE_URL`, migrations, or database setup before the server starts.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Single-file Linux executable

Install Zig 0.15.2, then build the production assets and Burrito executable:

```sh
MIX_ENV=prod mix burrito.build
```

The executable is written to `burrito_out/socketything_linux_x86_64`. Run it
with a production secret and optional host and port:

```sh
SECRET_KEY_BASE="$(mix phx.gen.secret)" PHX_HOST=localhost PORT=4000 \
  ./burrito_out/socketything_linux_x86_64
```

Ready to run in production? Please [check our deployment guides](https://phoenix.hexdocs.pm/deployment.html).

## Learn more

* Official website: https://www.phoenixframework.org/
* Guides: https://phoenix.hexdocs.pm/overview.html
* Docs: https://phoenix.hexdocs.pm
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix
