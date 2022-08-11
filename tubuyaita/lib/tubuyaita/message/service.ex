defmodule Tubuyaita.Message do
  @moduledoc false
  alias Tubuyaita.{Repo, Crypto}

  @spec insert_message(String.t(), String.t(), String.t()) :: :ok | :err
  def insert_message(contents, publicKey, sign) do
    content_hash = Crypto.hash(contents)
    %{"timestamp" => timestamp} = Jason.decode!(contents)

    with {:ok, datetime} <- Ecto.Type.cast(:naive_datetime_usec, DateTime.from_unix!(timestamp, :millisecond) |> DateTime.to_naive) do
      {:ok, _msg} =
        Repo.insert(%Tubuyaita.Message.Message {
          contents_hash: content_hash,
          created_at: datetime,
          public_key: Base.decode16!(publicKey, case: :mixed),
          raw_message: contents,
          signature: Base.decode16!(sign, case: :mixed),
        })
        :ok
    else
      _ -> :err
    end
  end

end
