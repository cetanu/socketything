defmodule SocketythingWeb.UserSocket do
  use Phoenix.Socket

  channel "presence:*", SocketythingWeb.PresenceChannel

  @impl true
  def connect(_params, socket, _connect_info) do
    viewer_id =
      12
      |> :crypto.strong_rand_bytes()
      |> Base.url_encode64(padding: false)

    {:ok, assign(socket, :viewer_id, viewer_id)}
  end

  @impl true
  def id(socket), do: "viewer_socket:#{socket.assigns.viewer_id}"
end
