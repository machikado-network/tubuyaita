defmodule TubuyaitaWeb.Api.V1.MessagesView do
  use TubuyaitaWeb, :view

  def render("message.json", %{}) do
    %{
      "publicKey": "abc"
    }
  end

  def render("error.json", %{}) do
    %{
      "error": "Sign failed"
    }
  end
end
