defmodule Tubuyaita.Crypto do
  @moduledoc false
  version = "0.3.2"

  use RustlerPrecompiled,
    otp_app: :tubuyaita,
    crate: "tubuyaita_crypto",
    base_url:
      "https://github.com/machikado-network/tubuyaita-crypto/releases/download/v#{version}",
    force_build: System.get_env("RUSTLER_PRECOMPILATION_EXAMPLE_BUILD") in ["1", "true"],
    version: version

  @doc """
    Tubuyaita.Message.Message用の、hexでencodeされたものをverifyする関数
  """
  @spec verify_message(String.t(), String.t(), String.t()) :: boolean()
  def verify_message(_message, _public_key, _sign), do: :erlang.nif_error(:nif_not_loaded)

  @doc """
  verify binary message with public key and sign
  """
  @spec verify(binary(), binary(), binary()) :: boolean()
  def verify(_message, _public_key, _sign), do: :erlang.nif_error(:nif_not_loaded)

  @doc """
  hash the message.
  """
  @spec hash(binary()) :: binary()
  def hash(_message), do: :erlang.nif_error(:nif_not_loaded)

  @doc """
    Returns {SecretKey, PublicKey}.
  """
  @spec generate_keypair() :: {binary(), binary()}
  def generate_keypair(), do: :erlang.nif_error(:nif_not_loaded)

  @spec sign(String.t(), binary(), binary()) :: binary()
  def sign(_message, _secret_key, _public_key), do: :erlang.nif_error(:nif_not_loaded)

  @spec from_hex(String.t()) :: binary()
  def from_hex(_message), do: :erlang.nif_error(:nif_not_loaded)

  @spec to_hex(binary()) :: String.t()
  def to_hex(_binary), do: :erlang.nif_error(:nif_not_loaded)
end
