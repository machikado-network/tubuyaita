defmodule Tubuyaita.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:message) do
      add(:content_hash, :string, null: false)
      add(:timestamp, :timestamp, null: false)
      add(:public_key, :binary, null: false)
      add(:raw_message, :binary, null: false)
    end
    create index(:message, [:timestamp])
    create index(:message, [:public_key])
    create index(:message, [:content_hash])
  end
end
