defmodule TubuyaitaWeb.Api.V1.MetaController do
  @moduledoc false
  use TubuyaitaWeb, :controller

  def get(conn, _) do
    conn
    |> put_status(201)
    |> render(
         "meta.json",
         %{
           name: Application.fetch_env!(:tubuyaita, :name),
           administrator: Application.fetch_env!(:tubuyaita, :administrator),
           icon_url: Application.fetch_env!(:tubuyaita, :icon_url)
         })
  end
end
