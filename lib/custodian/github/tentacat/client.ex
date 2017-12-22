defmodule Custodian.Github.Tentacat.Client do
  @moduledoc """
  Provides an implementation of the `Custodian.Github.Client` behaviour with
  the GitHub API.

  This provides two different authentication methods for interacting
  with the GitHub v3 API over HTTPS.
  """

  @behaviour Custodian.Github.Client

  alias JOSE.{JWK, JWS, JWT}
  alias Tentacat.Client
  alias Tentacat.App.Installations

  @doc """
  App authentication with the GitHub API client using the app's private key.

  This token has limited functionality and is mostly good for getting a token to be used on individual repos. [More info].

  [More info]: https://developer.github.com/apps/building-github-apps/authentication-options-for-github-apps/#authenticating-as-a-github-app
  """
  @spec app :: Tentacat.Client.t()
  def app do
    key = private_key(Application.get_env(:custodian, :github_key))
    signed = JWT.sign(key, %{"alg" => "RS256"}, jwt_payload())

    {_, token} = JWS.compact(signed)

    Client.new(%{jwt: token})
  end

  @doc """
  Installation authentication with the GitHub API client using an access
  token.

  This token is created for a specific installation of the app. Useful for
  taking action on specific repos. [More info].

  [More info]: https://developer.github.com/apps/building-github-apps/authentication-options-for-github-apps/#authenticating-as-an-installation
  """
  @spec installation(integer) :: struct
  def installation(installation_id) do
    {201, %{"token" => token}} = Installations.token(installation_id, app())

    Client.new(%{access_token: token})
  end

  @spec private_key(tuple) :: list
  defp private_key({:file, file_path}) do
    JWK.from_pem_file(file_path)
  end

  defp private_key({:system, config}) do
    JWK.from_pem(System.get_env(config))
  end

  @spec jwt_payload :: map
  defp jwt_payload do
    now = DateTime.to_unix(DateTime.utc_now())

    %{
      "iat" => now,
      "exp" => now + 10 * 60,
      "iss" => "7528"
    }
  end
end
