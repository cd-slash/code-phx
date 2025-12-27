defmodule CodingCoordinatorWeb.PageController do
  use CodingCoordinatorWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
