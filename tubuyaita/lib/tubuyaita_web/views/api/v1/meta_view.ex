defmodule TubuyaitaWeb.Api.V1.MetaView do
  @moduledoc false

  def render("meta.json", %{name: name, administrator: administrator, icon_url: icon_url}) do
    %{name: name, administrator: administrator, icon_url: icon_url}
  end
end
