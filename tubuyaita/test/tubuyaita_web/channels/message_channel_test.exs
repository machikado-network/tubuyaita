defmodule TubuyaitaWeb.MessageChannelTest do
  use TubuyaitaWeb.ChannelCase

  setup do
    {:ok, _, socket} =
      TubuyaitaWeb.UserSocket
      |> socket("public_key", %{some: :assign})
      |> subscribe_and_join(TubuyaitaWeb.MessageChannel, "message")

    %{socket: socket}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from!(socket, "broadcast", %{"some" => "data"})
    assert_push "broadcast", %{"some" => "data"}
  end

  test "send_message", %{socket: socket} do
    {secret, public} = Tubuyaita.Crypto.generate_keypair()
    content = ~s/{"content": "abc", "timestamp": 1660828964067}/
    sign = Tubuyaita.Crypto.sign(Tubuyaita.Crypto.hash(content), secret, public)
    msg = %{"contents" => content, "publicKey" => Tubuyaita.Crypto.to_hex(public), "sign" => Tubuyaita.Crypto.to_hex(sign)}
    push(socket, "post_message", msg)
    assert_push "create_message", msg
  end

  test "send_message_fail", %{socket: socket} do
    {secret, public} = Tubuyaita.Crypto.generate_keypair()
    {_secret2, public2} = Tubuyaita.Crypto.generate_keypair()
    content = ~s/{"content": "abc", "timestamp": 1660828964067}/
    sign = Tubuyaita.Crypto.sign(Tubuyaita.Crypto.hash(content), secret, public)
    msg = %{"contents" => content, "publicKey" => Tubuyaita.Crypto.to_hex(public2), "sign" => Tubuyaita.Crypto.to_hex(sign)}
    ref = push(socket, "post_message", msg)
    assert_reply ref, :error, %{reason: "invalid_json"}
  end
end
