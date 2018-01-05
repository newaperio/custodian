defmodule Custodian.Github.ClientTest do
  use ExUnit.Case, async: true

  @github Application.get_env(:custodian, :github_api)

  def token_fixture do
    """
    eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.
    eyJleHAiOjE1MTM4ODMwMjEsImlhdCI6MTUxMzg4MjQyMSwiaXNzIjoiNzUyOCJ9.
    Z_SM2dep79JS-VCADZIHQNK6s8xjHgiFOtSAtiLbQBdo-ozyw7jsn3kWRqIu4GtTKVsLd97p4sDp
    4hJjEPhkBouG5iGZ1usM8UivzaXfYam1ikgncocVPa2fe1rHrQTIjHyX_5sV9EdsNYKrxrygs5p3
    -OoL6bAoaRpwlN80Spzmcof9VhjQWxS33tofOx7DBlIX-GqZmUf1AW_4qGL9moYSlmzB9VoVuonu
    s24Pbo8_Hnvo9Qh5mkl1iGOWLWGERVT5_Jw3fZg1bXgSYTKstpX_UTh8JSYhMB1uWHPFq1nsd8hy
    29Pb6ssRcfDkEMXoKSKy3_QDjX1KWmyEGYnZxQ
    """
    |> String.replace("\n", "")
  end

  test "generates a client with JWT" do
    client = @github.Client.app()

    assert client.auth.jwt == token_fixture()
    assert_received :app
  end

  test "generates installation with installation_id" do
    client = @github.Client.installation(1)

    assert client.auth.access_token == "token"
    assert_received {:token, 1}
  end
end
