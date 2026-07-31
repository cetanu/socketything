defmodule SocketythingWeb.PresenceChannel do
  use SocketythingWeb, :channel

  @impl true
  def join("presence:" <> page, _payload, socket) when page != "" do
    socket = assign(socket, :page, page)

    send(self(), :after_join)

    {:ok, %{viewer_id: socket.assigns.viewer_id}, socket}
  end

  def join(_topic, _payload, _socket) do
    {:error, %{reason: "invalid topic"}}
  end

  @impl true
  def handle_info(:after_join, socket) do
    {:ok, _presence_ref} =
      SocketythingWeb.Presence.track(
        socket,
        socket.assigns.viewer_id,
        %{
          joined_at: System.system_time(:second)
        }
      )

    push(
      socket,
      "presence_state",
      SocketythingWeb.Presence.list(socket)
    )

    {:noreply, socket}
  end

  @impl true
  def handle_in("cursor", %{"x" => x, "y" => y}, socket)
      when is_number(x) and is_number(y) and
             x > 0 and x < 1 and
             y > 0 and y < 1 do
    broadcast_from!(socket, "cursor", %{viewer_id: socket.assigns.viewer_id, x: x, y: y})

    {:noreply, socket}
  end

  def handle_in("cursor", _payload, socket) do
    {:reply, {:error, %{reason: "invalid payload"}}, socket}
  end
end
