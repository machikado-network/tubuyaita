defmodule TubuyaitaWeb.Api.V1.MessagesView do
  use TubuyaitaWeb, :view

  def render("message.json", %{message: message}) do
    message
  end

  def render("messages.json", %{messages: messages}) do
    messages
  end

  def render("error.json", %{error: error}) do
    %{
      error: to_string(error)
    }
  end
end
