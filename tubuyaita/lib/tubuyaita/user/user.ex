defmodule Tubuyaita.User.User do
  use Ecto.Schema

  @primary_key {:public_key, :binary, []}
  schema "user" do
    field(:raw_data, :binary)
    field(:signature,:binary)
  end
end
