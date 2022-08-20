defmodule Tubuyaita.MessagesTest do
  use Tubuyaita.DataCase
  alias Tubuyaita.Message

  defp insert_message(timestamp, text) do
    contents = Jason.encode!(%{timestamp: timestamp, text: text})
    Message.insert_message(contents, "", "")
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

    Message.get_messages(:latest, 1)
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

    Message.get_messages(:latest, 100)
  end

end
