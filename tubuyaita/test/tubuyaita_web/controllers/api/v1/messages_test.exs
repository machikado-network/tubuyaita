defmodule TubuyaitaWeb.APIv1MessagesTest do
  use TubuyaitaWeb.ConnCase

  test "GET /api/v1/messages", %{conn: conn} do
    conn = get(conn, "/api/v1/messages")
    assert json_response(conn, 200) == []
  end
end
