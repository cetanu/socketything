defmodule SocketythingWeb.PresenceChannelTest do
  use ExUnit.Case, async: false

  import Phoenix.ChannelTest

  alias SocketythingWeb.{PresenceChannel, UserSocket}

  @endpoint SocketythingWeb.Endpoint

  test "the user socket assigns a unique viewer identity" do
    assert {:ok, socket} = connect(UserSocket, %{})
    assert byte_size(socket.assigns.viewer_id) == 16
    assert UserSocket.id(socket) == "viewer_socket:#{socket.assigns.viewer_id}"
  end

  test "a viewer joins a page and is tracked by Presence" do
    viewer_id = "viewer-one"

    assert {:ok, %{viewer_id: ^viewer_id}, _socket} =
             socket(UserSocket, nil, %{viewer_id: viewer_id})
             |> subscribe_and_join(PresenceChannel, "presence:home")

    assert_push "presence_state", state
    assert %{^viewer_id => %{metas: [%{joined_at: joined_at}]}} = state
    assert is_integer(joined_at)
  end

  test "empty and unrelated topics are rejected" do
    socket = socket(UserSocket, nil, %{viewer_id: "viewer-one"})

    assert {:error, %{reason: "invalid topic"}} =
             subscribe_and_join(socket, PresenceChannel, "presence:")

    assert {:error, %{reason: "invalid topic"}} =
             subscribe_and_join(socket, PresenceChannel, "other:home")
  end

  test "valid cursor positions are broadcast to the other viewers" do
    viewer_id = "viewer-one"

    assert {:ok, _, socket} =
             socket(UserSocket, nil, %{viewer_id: viewer_id})
             |> subscribe_and_join(PresenceChannel, "presence:home")

    push(socket, "cursor", %{"x" => 0.25, "y" => 0.75})

    assert_broadcast "cursor", %{viewer_id: ^viewer_id, x: 0.25, y: 0.75}
  end

  test "invalid cursor positions are rejected" do
    assert {:ok, _, socket} =
             socket(UserSocket, nil, %{viewer_id: "viewer-one"})
             |> subscribe_and_join(PresenceChannel, "presence:home")

    for payload <- [
          %{"x" => 0, "y" => 0.5},
          %{"x" => 0.5, "y" => 1},
          %{"x" => "0.5", "y" => 0.5},
          %{}
        ] do
      ref = push(socket, "cursor", payload)
      assert_reply ref, :error, %{reason: "invalid payload"}
    end
  end
end
