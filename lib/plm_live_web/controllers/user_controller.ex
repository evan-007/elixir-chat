defmodule PLMLiveWeb.UserController do
  use PLMLiveWeb, :controller

  alias PLMLive.Chats
  alias PLMLive.Chats.User

  action_fallback PLMLiveWeb.FallbackController

  def index(conn, _params) do
    users = Chats.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Chats.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Chats.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Chats.get_user!(id)

    with {:ok, %User{} = user} <- Chats.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Chats.get_user!(id)
    with {:ok, %User{}} <- Chats.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
