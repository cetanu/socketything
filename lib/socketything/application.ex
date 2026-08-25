defmodule Socketything.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {DNSCluster, query: Application.get_env(:socketything, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Socketything.PubSub},
      SocketythingWeb.Presence,
      SocketythingWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Socketything.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    SocketythingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
