defmodule Tubuyaita.User do
  @moduledoc false
  alias Tubuyaita.{Repo, Crypto}
  import Ecto.Query

  @spec create_or_update_user(binary(), binary(), binary()) :: :ok | {:error, keyword()}
  def create_or_update_user(public_key, data, sign) do
    data_hash = Crypto.hash(data)

    with {:ok, pk} <- Crypto.from_hex(public_key),
         {:ok, sign} <- Crypto.from_hex(sign),
         true <- Crypto.verify(data_hash, pk, sign),
         {:ok, _msg} <-
           Repo.insert(
             %Tubuyaita.User.User{
               public_key: pk,
               raw_data: data,
               signature: sign
             },
             on_conflict: [
               set: [
                 raw_data: data,
                 signature: sign
               ]
             ],
             conflict_target: :public_key
           ) do
      :ok
    else
      false -> {:error, :invalid_signature}
      {:error, msg} -> {:error, msg}
    end
  end

  @spec get_user(String.t()) :: %Tubuyaita.User.User{} | nil
  def get_user(public_key) do
    with {:ok, public_key} <- Crypto.from_hex(public_key) do
      Repo.get_by(Tubuyaita.User.User, public_key: public_key)
    else
      _ -> nil
    end
  end
end
