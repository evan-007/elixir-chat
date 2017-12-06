defmodule PLMLiveWeb.RoomMembershipView do
  use PLMLiveWeb, :view
  alias PLMLiveWeb.RoomMembershipView

  def render("index.json", %{room_memberships: room_memberships}) do
    %{data: render_many(room_memberships, RoomMembershipView, "room_membership.json")}
  end

  def render("show.json", %{room_membership: room_membership}) do
    %{data: render_one(room_membership, RoomMembershipView, "room_membership.json")}
  end

  def render("room_membership.json", %{room_membership: room_membership}) do
    %{id: room_membership.id}
  end
end
