defmodule Tubuyaita.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:message, primary_key: false) do
      add(:contents_hash, :string, null: false, primary_key: true)
      add(:created_at, :timestamp, null: false)
      add(:public_key, :binary, null: false)
      add(:raw_message, :binary, null: false)
      add(:signature, :binary, null: false)
    end
    create index(:message, [:created_at])
    create index(:message, [:public_key])
    create unique_index(:message, [:contents_hash])
  end
end
