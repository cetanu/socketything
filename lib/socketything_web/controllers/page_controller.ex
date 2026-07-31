defmodule SocketythingWeb.PageController do
  use SocketythingWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
