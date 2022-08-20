defmodule Tubuyaita.Message do
  @moduledoc false
  alias Tubuyaita.{Repo, Crypto}
  import Ecto.Query
  @type cursor() :: :latest | %{before: %{time: NaiveDateTime.t(), contents_hash: binary()}}

  @doc """
  送られてきたメッセージをデータベースに追加します。

  ## 引数

  - contents: メッセージ本文がJSON形式でstringifyされている文字列です。
  - publicKey: signを署名した公開鍵です。
  - sign: contentsのhashをpublicKeyで署名したものです。

  """
  @spec insert_message(String.t(), String.t(), String.t()) ::
          :ok | {:err, keyword()}
  def insert_message(contents, publicKey, sign) do
    content_hash = Crypto.hash(contents)

    with {:ok, %{"timestamp" => timestamp}} <- Jason.decode(contents),
         {:ok, timestamp} <- DateTime.from_unix(timestamp, :millisecond),
         true <- Tubuyaita.Crypto.verify_message(contents, publicKey, sign),
         {:ok, datetime} <-
           Ecto.Type.cast(
             :naive_datetime_usec,
             timestamp
             |> DateTime.to_naive()
           ),
         {:ok, _msg} <-
           Repo.insert(%Tubuyaita.Message.Message{
             contents_hash: content_hash,
             created_at: datetime,
             public_key: Base.decode16!(publicKey, case: :mixed),
             raw_message: contents,
             signature: Base.decode16!(sign, case: :mixed)
           }) do
      :ok
    else
      {:error, %Jason.DecodeError{}} -> {:error, :invalid_json}
      false -> {:error, :invalid_json}
      :error -> {:error, :invalid_timestamp}
      {:error, atom} -> {:error, atom}
      _ -> {:error, :conflict}
    end
  end

  @spec get_messages(cursor(), pos_integer()) :: :ok | :err
  def get_messages(cursor, limit)

  def get_messages(:latest, limit) do
    from(m in Tubuyaita.Message.Message,
      select: m,
      order_by: [desc: m.created_at, desc: m.contents_hash],
      limit: ^limit
    )
    |> Repo.all()
  end

  def get_messages(%{before: %{time: time, contents_hash: hash}}, limit) do
    from(m in Tubuyaita.Message.Message,
      select: m,
      where: m.created_at < ^time or (m.created_at == ^time and m.contents_hash < ^hash),
      order_by: [desc: m.created_at, desc: m.contents_hash],
      limit: ^limit
    )
    |> Repo.all()
  end
end
