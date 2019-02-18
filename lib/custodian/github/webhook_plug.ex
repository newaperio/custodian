defmodule Custodian.Github.WebhookPlug do
  @moduledoc false
  import Plug.Conn

  def init(options), do: options

  def call(conn, _) do
    secret = Application.get_env(:custodian, :github_webhook_secret)

    ["sha1=" <> header] = get_req_header(conn, "x-hub-signature")
    {:ok, body, _} = read_body(conn)

    signature =
      :sha |> :crypto.hmac(secret, body) |> Base.encode16(case: :lower)

    if Plug.Crypto.secure_compare(signature, header) do
      conn
    else
      conn |> send_resp(:forbidden, "") |> halt
    end
  end
end
