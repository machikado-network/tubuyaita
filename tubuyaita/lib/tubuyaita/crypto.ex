defmodule Tubuyaita.Crypto do
  @moduledoc false
  version = "0.1.5"

  use RustlerPrecompiled,
      otp_app: :tubuyaita,
      crate: "tubuyaita_crypto",
      base_url:
        "https://github.com/machikado-network/tubuyaita-crypto/releases/download/v#{version}",
      force_build: System.get_env("RUSTLER_PRECOMPILATION_EXAMPLE_BUILD") in ["1", "true"],
      version: version

  @spec verify(String.t(), String.t(), String.t()) :: Bool.t()
  def verify(_message, _public_key, _sign), do: :erlang.nif_error(:nif_not_loaded)

  @spec hash(String.t()) :: String.t()
  def hash(_message), do: :erlang.nif_error(:nif_not_loaded)
end
