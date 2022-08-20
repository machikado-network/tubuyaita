defmodule TubuyaitaWeb.Api.V1.MessagesView do
  use TubuyaitaWeb, :view
  alias Tubuyaita.Crypto

  def render("message.json", %{message: message}) do
    message
  end

  def render("messages.json", %{messages: messages}) do
    messages
    |> Enum.map(fn e ->
      %{
        contents_hash: Crypto.to_hex(e.contents_hash),
        created_at: e.created_at|>DateTime.from_naive!("Etc/UTC")|>DateTime.to_unix(:millisecond),
        public_key: Crypto.to_hex(e.public_key),
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
