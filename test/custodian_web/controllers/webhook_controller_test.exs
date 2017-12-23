defmodule CustodianWeb.WebhookControllerTest do
  use CustodianWeb.ConnCase

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("x-github-event", "installation")

    {:ok, conn: conn}
  end

  test "returns 204 empty response on receive", %{conn: conn} do
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

  test "returns 400 on unsupported event", %{conn: conn} do
    conn =
      conn
      |> put_req_header("x-github-event", "nonsense")

    conn = post(conn, webhook_path(conn, :receive), %{})
    body = json_response(conn, 400)

    assert body["errors"]["detail"] == "Unsupported event"
    assert response(conn, 400)
  end
end
