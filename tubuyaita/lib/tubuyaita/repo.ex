defmodule Tubuyaita.Repo do
  use Ecto.Repo,
    otp_app: :tubuyaita,
    adapter: Ecto.Adapters.Postgres
end
