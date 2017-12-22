defmodule Custodian.Github.Mockcat.Client do
  @behaviour Custodian.Github.Client

  defstruct auth: nil

  def app() do
    send(self(), :app)

    key =
      Application.get_env(:custodian, :github_key)
      |> elem(1)
      |> JOSE.JWK.from_pem_file()

    payload = %{"exp" => 1_513_883_021, "iat" => 1_513_882_421, "iss" => "7528"}
    signed = JOSE.JWT.sign(key, %{"alg" => "RS256"}, payload)
    {_, token} = JOSE.JWS.compact(signed)

    %__MODULE__{auth: %{jwt: token}}
  end

  def installation(installation_id) do
    send(self(), {:token, installation_id})

    %__MODULE__{auth: %{access_token: "token"}}
  end
end
