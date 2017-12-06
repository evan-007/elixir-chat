defmodule PLMLiveWeb.MessageController do
  use PLMLiveWeb, :controller

  alias PLMLive.Chats
  alias PLMLive.Chats.Message

  action_fallback PLMLiveWeb.FallbackController

  def index(conn, _params) do
    messages = Chats.list_messages()
    render(conn, "index.json", messages: messages)
  end

  def create(conn, %{"message" => message_params}) do
    with {:ok, %Message{} = message} <- Chats.create_message(message_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", message_path(conn, :show, message))
      |> render("show.json", message: message)
    end
  end

  def show(conn, %{"id" => id}) do
    message = Chats.get_message!(id)
    render(conn, "show.json", message: message)
  end

  def update(conn, %{"id" => id, "message" => message_params}) do
    message = Chats.get_message!(id)

    with {:ok, %Message{} = message} <- Chats.update_message(message, message_params) do
      render(conn, "show.json", message: message)
    end
  end

  def delete(conn, %{"id" => id}) do
    message = Chats.get_message!(id)
    with {:ok, %Message{}} <- Chats.delete_message(message) do
      send_resp(conn, :no_content, "")
    end
  end
end
