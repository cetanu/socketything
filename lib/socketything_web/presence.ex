defmodule SocketythingWeb.Presence do
  use Phoenix.Presence,
    otp_app: :socketything,
    pubsub_server: Socketything.PubSub
end
