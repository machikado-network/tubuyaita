defmodule Tubuyaita.UsersTest do
  use Tubuyaita.DataCase
  alias Tubuyaita.{User, Crypto}

  test "create a user" do
    msg = ~s/{"username": "abc"}/
    {secret, public} = Crypto.generate_keypair()
    {:ok, sign} = Crypto.sign(Crypto.hash(msg), secret, public)
    IO.inspect public
    assert User.create_or_update_user(Crypto.to_hex(public), msg, Crypto.to_hex(sign)) == :ok
    %User.User{public_key: pk, signature: s, raw_data: r} = User.get_user(Crypto.to_hex(public))
    assert pk == public
    assert s == sign
    assert r == msg

  end

  test "update a user" do
    msg = ~s/{"username": "123"}/
    {secret, public} = Crypto.generate_keypair()
    {:ok, sign} = Crypto.sign(Crypto.hash(msg), secret, public)
    assert User.create_or_update_user(Crypto.to_hex(public), msg, Crypto.to_hex(sign)) == :ok

    msg2 = ~s/{"username": "cde"}/
    {:ok, sign2} = Crypto.sign(Crypto.hash(msg2), secret, public)
    assert User.create_or_update_user(Crypto.to_hex(public), msg2, Crypto.to_hex(sign2)) == :ok

    %User.User{public_key: pk, signature: s, raw_data: r} = User.get_user(Crypto.to_hex(public))
    assert pk == public
    assert s == sign2
    assert r == msg2
  end
end
