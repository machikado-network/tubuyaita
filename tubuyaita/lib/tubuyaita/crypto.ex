defmodule Tubuyaita.Crypto do
  @moduledoc false
  version = "0.1.3"

  use RustlerPrecompiled,
      otp_app: :tubuyaita,
      crate: "tubuyaita_crypto",
      base_url:
        "https://github.com/machikado-network/tubuyaita-crypto/releases/download/v#{version}",
      force_build: System.get_env("RUSTLER_PRECOMPILATION_EXAMPLE_BUILD") in ["1", "true"],
      version: version

  def verify(_message, _public_key, _sign), do: :erlang.nif_error(:nif_not_loaded)
end
