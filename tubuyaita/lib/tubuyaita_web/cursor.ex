defmodule TubuyaitaWeb.Cursor do
  require Logger
  @moduledoc """
  JSONをBase64URLでエンコードしたものをカーソルとする。
  tがtimestamp,hがcontents_hash,vがバージョンを表す。
  サーバー側の署名はないのでこの値を信頼しないこと。
  同じバージョンのapiに対して行われたリクエストではカーソルの有効性を保証する。
  """
  @spec parse(String.t()) :: {:ok, Tubuyaita.Message.cursor()} | :err
  def parse(cursor) do
    with {:ok, d} <- Base.url_decode64(cursor),
         {:ok, %{"t" => time, "h" => contents_hash, "v" => 1}} <- Jason.decode(d),
         {:ok, time} <- time |> DateTime.from_unix(:millisecond),
         {:ok, contents_hash} <- Base.url_decode64(contents_hash) do
      {:ok, %{before: %{time: time |> DateTime.to_naive(), contents_hash: contents_hash}}}
    else
      e ->
        Logger.warning("an error occured while parsing cursor.", %{
          cursor: cursor,
          error: e
        })

        :err
    end
  end

  @spec encode(Tubuyaita.Message.cursor()) :: String.t()
  def encode(%{before: %{time: time, contents_hash: contents_hash}}) do
    %{
      "t" => time |> DateTime.from_naive!("Etc/UTC") |> DateTime.to_unix(:millisecond),
      "h" => contents_hash |> Base.url_encode64(),
      "v" => 1
    }
    |> Jason.encode!()
    |> Base.url_encode64()
  end
end
