defmodule CustodianWeb.WebhookController do
  @moduledoc """
  Responds to the GitHub webhook and sends the payload for processing.
  """
  use CustodianWeb, :controller

  alias Custodian.Github
  alias Plug.Conn

  action_fallback(CustodianWeb.FallbackController)

  def receive(conn, params) do
    Appsignal.increment_counter("webhook_count", 1)

    with {:ok, _bots} <- Github.process_event(event(conn), params) do
      send_resp(conn, :no_content, "")
    end
  end

  defp event(conn) do
    conn |> Conn.get_req_header("x-github-event") |> List.last()
  end
end
