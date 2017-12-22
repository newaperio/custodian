defmodule Custodian.Github.Tentacat.References do
  @moduledoc """
  Provides an implementation of the `Custodian.Github.References` behaviour
  with the GitHub API.

  This module provides a function to delete branches via the GitHub v3 API over
  HTTPS.
  """

  @behaviour Custodian.Github.References

  alias Custodian.Bots.Bot
  alias Custodian.Github.Tentacat.Client
  alias Tentacat.References

  @doc """
  Removes the `branch` from the repo connected to `bot`.

  [More info].

  ## Examples

      iex> remove(%Bot{}, "pr-1")
      {201, ""}

  [More info]: https://developer.github.com/v3/git/refs/#delete-a-reference
  """
  @spec remove(Bot.t(), String.t()) :: tuple
  def remove(bot, branch) do
    References.remove(
      bot.owner,
      bot.name,
      "heads/#{branch}",
      Client.installation(bot.installation_id)
    )
  end
end
