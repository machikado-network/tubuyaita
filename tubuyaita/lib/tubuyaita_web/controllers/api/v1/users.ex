defmodule TubuyaitaWeb.Api.V1.UsersController do
  @moduledoc false
  use TubuyaitaWeb, :controller

  @spec put(Plug.Conn.t(), %{publicKey: String.t(), sign: String.t(), data: String.t()}) :: Plug.Conn.t()
  def put(conn, %{"data" => data, "sign" => sign, "publicKey" => public_key} = user) do
    with :ok <- Tubuyaita.User.create_or_update_user(public_key, data, sign) do
      conn
      |> put_status(200)
      |> render("user.json", %{user: user})
    else
      {:error, err} ->
        conn
        |> put_status(401)
        |> render("error.json", %{error: err})
    end
  end

  @spec get(Plug.Conn.t(), %{publicKey: String.t()}) :: Plug.Conn.t()
  def get(conn, %{"publicKey" => public_key}) do
    case Tubuyaita.User.get_user public_key do
      nil -> conn
             |> put_status(401)
             |> render("error.json", %{error: :not_found})
      user ->
        conn
        |> put_status(200)
        |> render("user.json", %{user: user})
    end
  end

end
