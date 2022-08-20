defmodule TubuyaitaWeb.Api.V1.MessagesController do
  @moduledoc false
  use TubuyaitaWeb, :controller
  alias TubuyaitaWeb.Cursor
  @default_list_limit 100
  @max_list_limit 100
  @spec post(Plug.Conn.t(), %{publicKey: String.t(), sign: String.t(), contents: String.t()}) ::
          Plug.Conn.t()
  def post(conn, %{"contents" => contents, "publicKey" => publicKey, "sign" => sign} = msg) do
    with :ok <- Tubuyaita.Message.insert_message(contents, publicKey, sign) do
      # send to all
      TubuyaitaWeb.Endpoint.broadcast "message", "create_message", msg
      conn
      |> put_status(201)
      |> render("message.json", %{message: msg})
    else
      {:error, err} ->
        conn
        |> put_status(401)
        |> render("error.json", %{error: err})
    end
  end

  def get(conn, %{"cursor" => cursor} = params) do
    with {:ok, cursor} <- Cursor.parse(cursor),
         {:ok, limit} <- get_limit(params) do
      _get(conn, cursor, limit)
    else
      {:error, err} ->
        conn
        |> put_status(400)
        |> render("error.json", %{error: err})

      _ ->
        conn
        |> put_status(400)
        |> render("error.json", %{error: :invalid_cursor})
    end
  end

  def get(conn, params) do
    with {:ok, limit} <- get_limit(params) do
      _get(conn, :latest, limit)
    else
      {:error, err} ->
        conn
        |> put_status(400)
        |> render("error.json", %{error: err})
    end
  end

  defp _get(conn, cursor, limit) do
    messages = Tubuyaita.Message.get_messages(cursor, limit)

    conn
    |> put_status(200)
    |> render("messages.json", %{
      messages:
        messages
        |> Enum.map(fn e ->
          %{
            contents_hash: Base.url_encode64(e.contents_hash),
            created_at: e.created_at,
            public_key: Base.url_encode64(e.public_key),
            raw_message: e.raw_message
          }
        end)
    })
  end

  defp get_limit(%{"limit" => limit}) do
    case Integer.parse(limit) do
      {limit, ""} when limit > @max_list_limit -> {:error, :limit_is_too_large}
      {limit, ""} -> {:ok, limit}
      _ -> {:error, :invalid_limit}
    end
  end

  defp get_limit(%{}) do
    {:ok, @default_list_limit}
  end
end
