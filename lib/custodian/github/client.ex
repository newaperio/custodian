defmodule Custodian.Github.Client do
  @moduledoc """
  Behaviour interface for taking actions on specific repos on GitHub.

  Implemented using [Tentacat] in `Custodian.Github.Tentacat.Client`. In tests,
  implemented as a mock in Mockcat.

  [Tentacat]: https://github.com/edgurgel/tentacat
  """

  @doc """
  Uses the configured private key to generate a JWT.

  In development, the key is loaded from `config/github_key.pem`. In test, it's
  loaded from `test/support/github_key.pem`. In production this is loaded from
  the `GITHUB_API_KEY` ENV var.

  This token is used to generate access tokens that can be used for repo
  actions. The JWT can only be used for generating new tokens.
  """
  @callback app() :: struct

  @doc """
  Uses the app JWT to generate an access token.

  This token can be used to take action on specific repos.
  """
  @callback installation(installation_id :: integer) :: struct
end
