defmodule TubuyaitaWeb.Api.V1.MessagesView do
  use TubuyaitaWeb, :view

  def render("message.json", %{message: message}) do
    message
  end

  def render("messages.json", %{messages: messages}) do
    messages
    |> Enum.map(fn e ->
      %{
        contents_hash: Base.url_encode64(e.contents_hash),
        created_at: e.created_at|>DateTime.from_naive!("Etc/UTC")|>DateTime.to_unix(:millisecond),
        public_key: Base.url_encode64(e.public_key),
        raw_message: e.raw_message
      }
    end)
  end

  def render("error.json", %{error: error}) do
    %{
      error: to_string(error)
    }
  end
end
