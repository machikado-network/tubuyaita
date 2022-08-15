defmodule TubuyaitaWeb.Api.V1.MessagesController do
  @moduledoc false
  use TubuyaitaWeb, :controller

  @spec post(Plug.Conn.t(), %{"publicKey": String.t(), "sign": String.t(), "contents": String.t()}) :: Plug.Conn.t()
  def post(conn, %{"contents" => contents, "publicKey" => publicKey, "sign" => sign} = msg) do
    with :ok <- Tubuyaita.Message.insert_message(contents, publicKey, sign) do
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
end
