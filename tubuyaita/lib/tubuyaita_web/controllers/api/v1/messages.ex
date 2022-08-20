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
    limit = Map.get(params, "limit", @default_list_limit)

    with {:ok, cursor} <- Cursor.parse(cursor) do
      _get(conn, cursor, limit)
    else
      _ ->
        conn
        |> put_status(400)
        |> render("error.json", %{error: :invalid_cursor})
    end
  end

  def get(conn, params) do
    limit = Map.get(params, "limit", @default_list_limit)

    _get(conn, :latest, limit)
  end

  defp _get(conn, _cursor, limit) when limit > @max_list_limit do
    conn
    |> put_status(400)
    |> render("error.json", %{error: :limit_is_too_large})
  end

  defp _get(conn, cursor, limit) do
    messages = Tubuyaita.Message.get_messages(cursor, limit)

    conn
    |> put_status(200)
    |> render("messages.json", %{messages: messages})
  end


end
