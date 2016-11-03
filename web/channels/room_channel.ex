defmodule PhoenixChat.RoomChannel do
  use Phoenix.Channel
  alias PhoenixChat.{Repo, Message}
  require Logger

  def join("rooms:lobby", message, socket) do
    Process.flag(:trap_exit, true)
    send(self, {:after_join, message})

    {:ok, socket}
  end

  def join("rooms:" <> _private_subtopic, _message, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_info({:after_join, msg}, socket) do
    broadcast! socket, "user:entered", %{user: msg["user"]}
    push socket, "join", %{status: "connected"}
    {:noreply, socket}
  end


  def terminate(reason, _socket) do
    Logger.debug"> leave #{inspect reason}"
    :ok
  end

  def handle_in("new:msg", %{"user" => user, "msg" => msg_params}, socket) do
    changeset = Message.changeset(%Message{}, msg_params)

      case Repo.insert(changeset) do
        {:ok, msg} ->
          broadcast! socket, "new:msg", %{
           user: user,
           msg:  msg
         }
          {:noreply, socket}
        {:error, changeset} ->
          {:noreply, socket}
      end
  end
end
