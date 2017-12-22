defmodule Custodian.Github.ClientTest do
  use ExUnit.Case, async: true

  @github Application.get_env(:custodian, :github_api)

  def token_fixture do
    """
    eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.
    eyJleHAiOjE1MTM4ODMwMjEsImlhdCI6MTUxMzg4MjQyMSwiaXNzIjoiNzUyOCJ9.
    nIBkLiU-w2eh4QntkQ8WmE-qsYmvDd9a-O9VvUMSpyKddndkz2xpMF9b3UnV-uQXuQ6ag45ap_HG
    2eBpGWclVPUV7vDk-oX-DmM7DLJ_8woCvdNnc3jUDhGW7OG9ajIGmK0o5fhZ8bqWHaUJofF0J-V9
    oCCeqV9Gfyu2CLKqC02PFfCLx3PvCMVsijEiylnXGjFUQNgf-erhVVH6R5z6q-JGFQ3P7Eqla8Qm
    VMleG6980dSXlF3HlKZTSEJLoI9iofEjGgB72C8vPz_XYV_WshNgqEffGqjHEGGFx9hO69FniHA8
    3NZlRp80R7-xcQpBZftN9hRjSvx7TJoySj1YBQ
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
