defmodule SocketythingWeb.PresenceChannel do
  use SocketythingWeb, :channel

  @impl true
  def join("presence:" <> page, _payload, socket) when page != "" do
    socket = assign(socket, :page, page)

    {:ok, %{viewer_id: socket.assigns.viewer_id}, socket}
  end

  def join(_topic, _payload, _socket) do
    {:error, %{reason: "invalid topic"}}
  end
end
