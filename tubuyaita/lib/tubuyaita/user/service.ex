defmodule Tubuyaita.User do
  @moduledoc false
  alias Tubuyaita.{Repo, Crypto}
  import Ecto.Query

  @spec create_or_update_user(String.t(), String.t(), String.t()) :: :ok | {:error, keyword()}
  def create_or_update_user(public_key, data, sign) do
    data_hash = Crypto.hash(data)

    on_conflict = [
      set: [
        raw_data: data,
        signature: Crypto.from_hex(sign)
      ]
    ]

    with true <- Crypto.verify(data_hash, Crypto.from_hex(public_key), Crypto.from_hex(sign)),
         {:ok, _msg} <- Repo.insert(
           %Tubuyaita.User.User {
             public_key: Crypto.from_hex(public_key),
             raw_data: data,
             signature: Crypto.from_hex(sign),
           },
           on_conflict: on_conflict,
         conflict_target: :public_key
         )
      do
      :ok
    else
      false -> {:error, :invalid_signature}
      {:error, msg} -> {:error, msg}
    end
  end

  @spec get_user(String.t()) :: %Tubuyaita.User.User{} | nil
  def get_user(public_key) do
    Repo.get_by(Tubuyaita.User.User, public_key: Crypto.from_hex(public_key))
  end

end
