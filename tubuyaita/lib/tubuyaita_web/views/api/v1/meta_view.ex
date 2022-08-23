defmodule TubuyaitaWeb.Api.V1.MetaView do
  @moduledoc false

  def render("meta.json", %{name: name, administrator: administrator}) do
    %{name: name, administrator: administrator}
  end
end
