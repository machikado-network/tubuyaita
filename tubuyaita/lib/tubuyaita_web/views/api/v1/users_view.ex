defmodule TubuyaitaWeb.Api.V1.UsersView do
  use TubuyaitaWeb, :view
  alias Tubuyaita.Crypto

  def render("user.json", %{
        user: %Tubuyaita.User.User{public_key: public_key, raw_data: data, signature: sign}
      }) do
    %{public_key: Crypto.to_hex(public_key), raw_data: data, signature: Crypto.to_hex(sign)}
  end

  def render("user.json", %{user: user}) do
    user
  end

  def render("error.json", %{error: error}) do
    %{
      error: error
    }
  end
end
