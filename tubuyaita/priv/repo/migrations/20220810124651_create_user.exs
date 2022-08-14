defmodule Tubuyaita.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:user, primary_key: false) do
      add(:public_key, :binary, null: false, primary_key: true)
      add(:raw_data, :binary, null: false)
      add(:signature, :binary, null: false)
    end
  end
end
