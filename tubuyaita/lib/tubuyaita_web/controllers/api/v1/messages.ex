defmodule TubuyaitaWeb.Api.V1.MessagesController do
  @moduledoc false
  use TubuyaitaWeb, :controller

#  @spec post(Plug.Conn.t(), %{publicKey: string, sign: string, contents: string}) :: Plug.Conn.t()
  def post(conn, %{"contents" => contents, "publicKey" => publicKey, "sign" => sign} = msg) do
    if Tubuyaita.Crypto.verify(contents, publicKey, sign) do
      Tubuyaita.Message.insert_message(contents, publicKey, sign)
      conn
      |> put_status(201)
      |> render("message.json", %{message: msg})
    else
      conn
      |> put_status(401)
      |> render("error.json", %{error: :signature_invalid})
    end
  end
end
