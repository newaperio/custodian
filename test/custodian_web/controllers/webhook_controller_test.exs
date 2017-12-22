defmodule CustodianWeb.WebhookControllerTest do
  use CustodianWeb.ConnCase

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("x-github-event", "installation")

    {:ok, conn: conn}
  end

  test "returns empty response on receive", %{conn: conn} do
    params = %{
      "action" => "created",
      "installation" => %{"id" => 1},
      "repositories" => [
        %{
          "full_name" => "lleger/gh-api-test",
          "id" => 1
        }
      ]
    }

    conn = post(conn, webhook_path(conn, :receive), params)
    assert response(conn, 204)
  end
end
