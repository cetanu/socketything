defmodule SocketythingWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :socketything

  socket "/socket", SocketythingWeb.UserSocket,
    websocket: [check_origin: ["https://vsyrakis.dev"]],
    longpoll: false

  plug :respond

  defp respond(%Plug.Conn{method: "GET", request_path: "/"} = conn, _opts) do
    Plug.Conn.send_resp(conn, 200, "ok")
  end

  defp respond(conn, _opts) do
    Plug.Conn.send_resp(conn, 404, "not found")
  end
end
