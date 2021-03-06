defmodule PLMLiveWeb.Router do
  use PLMLiveWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PLMLiveWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", PLMLiveWeb do
    pipe_through :api

    # none of these are actually used yet
    resources "/rooms", RoomController, except: [:new, :edit]
    resources "/users", UserController, except: [:new, :edit]
    resources "/messages", MessageController, except: [:new, :edit]
    resources "/room_memberships", RoomMembershipController, except: [:new, :edit]
  end
end
