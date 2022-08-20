defmodule TubuyaitaWeb.CursorTest do
  use ExUnit.Case
  alias Tubuyaita.Crypto
  alias TubuyaitaWeb.Cursor

  test "valid cursor" do
    time = NaiveDateTime.new!(~D[2022-08-17], ~T[23:00:07.000])
    hash = Crypto.hash("aaa")
    d = %{before: %{time: time, contents_hash: hash}}
    cur = Cursor.encode(d)
    assert {:ok, ^d} = Cursor.parse(cur)
  end
end
