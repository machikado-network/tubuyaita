defmodule Tubuyaita.MessagesTest do
  use Tubuyaita.DataCase
  alias Tubuyaita.{Message, Crypto}

  defp insert_message(timestamp, text) do
    contents = Jason.encode!(%{timestamp: timestamp, text: text})
    Message.insert_message(contents, "", "")
    Crypto.hash(contents)
  end

  test "get latest 1 message" do
    insert_message(
      DateTime.new!(~D[2022-08-02], ~T[22:45:40.050]) |> DateTime.to_unix(:millisecond),
      "aaa"
    )

    insert_message(
      DateTime.new!(~D[2022-08-02], ~T[22:46:00]) |> DateTime.to_unix(:millisecond),
      "bbb"
    )

    m = Message.get_messages(:latest, 1) |> Enum.at(0)
    assert Jason.decode!(m.raw_message)["text"] == "bbb"
  end

  test "get latest messages" do
    insert_message(
      DateTime.new!(~D[2022-08-02], ~T[22:45:40.050]) |> DateTime.to_unix(:millisecond),
      "aaa"
    )

    insert_message(
      DateTime.new!(~D[2022-08-02], ~T[22:46:00]) |> DateTime.to_unix(:millisecond),
      "bbb"
    )

    assert Message.get_messages(:latest, 100) |> Enum.map(&Jason.decode!(&1.raw_message)["text"]) ==
             ["bbb", "aaa"]
  end

  test "get messages with cursor" do
    hashA =
      insert_message(
        DateTime.new!(~D[2022-08-02], ~T[22:45:40.050]) |> DateTime.to_unix(:millisecond),
        "aaa"
      )

    hashB =
      insert_message(
        DateTime.new!(~D[2022-08-02], ~T[22:45:40.050]) |> DateTime.to_unix(:millisecond),
        "bbb"
      )

    hashC =
      insert_message(
        DateTime.new!(~D[2022-08-02], ~T[22:46:00]) |> DateTime.to_unix(:millisecond),
        "ccc"
      )

    # BのほうがAよりも先に書かれた扱いになる
    assert hashB < hashA

    assert Message.get_messages(:latest, 100) |> Enum.map(&Jason.decode!(&1.raw_message)["text"]) ==
             [
               "ccc",
               "bbb",
               "aaa"
             ]

    assert Message.get_messages(
             %{
               before: %{
                 time: NaiveDateTime.new!(~D[2022-08-02], ~T[22:46:00]),
                 contents_hash: hashC
               }
             },
             100
           )
           |> Enum.map(&Jason.decode!(&1.raw_message)["text"]) ==
             [
               "bbb",
               "aaa"
             ]

    assert Message.get_messages(
             %{
               before: %{
                 time: NaiveDateTime.new!(~D[2022-08-02], ~T[22:45:40.050]),
                 contents_hash: hashA
               }
             },
             100
           )
           |> Enum.map(&Jason.decode!(&1.raw_message)["text"]) ==
             [
               "bbb"
             ]

    assert Message.get_messages(
             %{
               before: %{
                 time: NaiveDateTime.new!(~D[2022-08-02], ~T[22:45:40.050]),
                 contents_hash: hashB
               }
             },
             100
           )
           |> Enum.map(&Jason.decode!(&1.raw_message)["text"]) ==
             [
             ]
  end
end
