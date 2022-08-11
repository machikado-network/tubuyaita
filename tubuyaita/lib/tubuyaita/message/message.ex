defmodule Tubuyaita.Message.Message do
  use Ecto.Schema

  @primary_key {:contents_hash, :string, []}
  schema "message" do
    field(:created_at, :naive_datetime_usec)
    field(:public_key, :binary)
    field(:raw_message, :binary)
    field(:signature, :binary)
  end
end
