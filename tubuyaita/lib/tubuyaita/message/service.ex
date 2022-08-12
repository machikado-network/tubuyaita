defmodule Tubuyaita.Message do
  @moduledoc false
  alias Tubuyaita.{Repo, Crypto}

  @doc """
  送られてきたメッセージをデータベースに追加します。

  ## 引数

  - contents: メッセージ本文がJSON形式でstringifyされている文字列です。
  - publicKey: signを署名した公開鍵です。
  - sign: contentsのhashをpublicKeyで署名したものです。

  """
  @spec insert_message(String.t(), String.t(), String.t())
        :: :ok | {:err, :invalid_signature} | {:err, :invalid_json} | {:err, :confrict}
  def insert_message(contents, publicKey, sign) do
    content_hash = Crypto.hash(contents)
    %{"timestamp" => timestamp} = Jason.decode!(contents)

    with {:ok, %{"timestamp" => timestamp}} = Jason.decode(contents),
         true <- Tubuyaita.Crypto.verify_message(contents, publicKey, sign),
         {:ok, datetime} <- Ecto.Type.cast(:naive_datetime_usec, DateTime.from_unix!(timestamp, :millisecond) |> DateTime.to_naive) do
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
      {:error, %Jason.DecodeError{}} -> {:err, :invalid_json}
      false -> {:err, :invalid_json}
      _ -> {:err, :confrict}
    end
  end

end
