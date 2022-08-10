defmodule Tubuyaita.User do
  use Ecto.Schema

  schema "user" do
    field(:public_key, :binary)
    field(:raw_data, :binary)
    field(:signature,:binary)
  end
end
