defmodule TubuyaitaWeb.MessageChannel do
  use TubuyaitaWeb, :channel

  @impl true
  def join("message", payload, socket) do
    {:ok, socket}
  end

  @spec handle_in(
          String.t(),
          %{contents: String.t(), publicKey: String.t(), sign: String.t()},
          Phoenix.Socket.t()
        ) :: {:noreply, Phoenix.Socket.t()} | {:stop, %{reason: String.t()}, Phoenix.Socket.t()}
  def handle_in(
        "post_message",
        %{"contents" => contents, "publicKey" => publicKey, "sign" => sign},
        socket
      ) do
    with :ok <- Tubuyaita.Message.insert_message(contents, publicKey, sign) do
      # send message to all
      broadcast(socket, "create_message", %{"contents" => contents, "publicKey" => publicKey, "sign" => sign})
      {:noreply, socket}
    else
      {:error, err} -> {:reply, {:error, %{reason: to_string(err)}}, socket}
    end
  end
end
