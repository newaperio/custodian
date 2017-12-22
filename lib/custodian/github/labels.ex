defmodule Custodian.Github.Labels do
  @moduledoc """
  Behaviour interface for interacting with labels on pull requests on GitHub.

  Implemented using [Tentacat] in `Custodian.Github.Tentacat.Labels`. In tests,
  implemented as a mock in Mockcat.

  [Tentacat]: https://github.com/edgurgel/tentacat
  """

  @typedoc """
  Pull request identifier as a tuple with the repo and integer ID.
  """
  @type pull_request :: {Custodian.Bots.Bot.t(), integer}

  @doc """
  Returns a list of strings representing all of the labels on a
  given pull request.
  """
  @callback all(pull_request :: pull_request) :: [String.t()]

  @doc """
  Adds the provided label(s) to the given pull request.
  """
  @callback add(
              pull_request :: pull_request,
              label :: String.t()
            ) :: pull_request

  @doc """
  Adds the provided label(s) to the given pull request.
  """
  @callback add(
              pull_request :: pull_request,
              labels :: [String.t()]
            ) :: pull_request

  @doc """
  Removes a given label from a given pull request.
  """
  @callback remove(
              pull_request :: pull_request,
              label :: String.t()
            ) :: pull_request
end
