defmodule CustodianWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use CustodianWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(CustodianWeb.ErrorView, :"404")
  end

  def call(conn, :error) do
    conn
    |> put_status(:bad_request)
    |> render(CustodianWeb.ErrorView, :"400")
  end
end
