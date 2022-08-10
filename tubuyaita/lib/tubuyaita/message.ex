defmodule Tubuyaita.Message do
  use Ecto.Schema

  schema "message" do
    field(:content_hash, :string)
    field(:timestamp, :naive_datetime)
    field(:public_key, :binary)
    field(:raw_message, :binary)
  end
end
