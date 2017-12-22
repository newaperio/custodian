defmodule Custodian.Github.Labels do
  @moduledoc """
  Behaviour interface for interacting with labels on pull requests on GitHub.

  Implemented using [Tentacat] in `Custodian.Github.Tentacat.Labels`. In tests,
  implemented as a mock in Mockcat.

  [Tentacat]: https://github.com/edgurgel/tentacat
  """

  alias Custodian.Github

  @doc """
  Returns a list of strings representing all of the labels on a
  given pull request.
  """
  @callback all(pull_request :: Github.pull_request()) :: [String.t()]

  @doc """
  Adds the provided label(s) to the given pull request.
  """
  @callback add(
              pull_request :: Github.pull_request(),
              label :: String.t()
            ) :: Github.pull_request()

  @doc """
  Adds the provided label(s) to the given pull request.
  """
  @callback add(
              pull_request :: Github.pull_request(),
              labels :: [String.t()]
            ) :: Github.pull_request()

  @doc """
  Removes a given label from a given pull request.
  """
  @callback remove(
              pull_request :: Github.pull_request(),
              label :: String.t()
            ) :: Github.pull_request()
end
