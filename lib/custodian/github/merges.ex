defmodule Custodian.Github.Merges do
  @moduledoc """
  Behaviour interface for merging branches on GitHub.

  Implemented using [Tentacat] in `Custodian.Github.Tentacat.Merges`.

  [Tentacat]: https://github.com/edgurgel/tentacat
  """

  @doc """
  Merges changes from master into the pull request's branch.
  """
  @callback merge(
              bot :: Custodian.Bots.Bot.t(),
              head :: String.t(),
              base :: String.t()
            ) :: tuple
end
