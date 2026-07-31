defmodule Socketything.Application do
  # See https://elixir.hexdocs.pm/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SocketythingWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:socketything, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Socketything.PubSub},
      SocketythingWeb.Presence,
      # Start a worker by calling: Socketything.Worker.start_link(arg)
      # {Socketything.Worker, arg},
      # Start to serve requests, typically the last entry
      SocketythingWeb.Endpoint
    ]

    # See https://elixir.hexdocs.pm/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Socketything.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SocketythingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
