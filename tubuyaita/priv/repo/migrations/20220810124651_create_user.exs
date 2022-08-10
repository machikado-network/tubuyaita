defmodule Tubuyaita.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:user) do
      add(:public_key, :binary, null: false)
      add(:raw_data, :binary, null: false)
      add(:signature, :binary, null: false)
    end
    create index(:user, [:public_key])
  end
end
