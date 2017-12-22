defmodule Custodian.Github.References do
  @moduledoc """
  Behaviour interface for interacting with branches on GitHub.

  Implemented using [Tentacat] in `Custodian.Github.Tentacat.References`.

  [Tentacat]: https://github.com/edgurgel/tentacat
  """

  @doc """
  Deletes the named branch on GitHub in the repo managed by the given bot.
  """
  @callback remove(bot :: Custodian.Bots.Bot.t(), branch :: String.t()) :: tuple
end
