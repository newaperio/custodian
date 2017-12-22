defmodule Custodian.Github.Tentacat.Merges do
  @moduledoc """
  Provides an implementation of the `Custodian.Github.Merges` behaviour with
  the GitHub API.

  This module provides a function to merge branches via the GitHub v3 API over
  HTTPS.
  """
  alias Custodian.Github.Tentacat.Client
  alias Tentacat.Repositories.Merges

  @doc """
  Merges commits from `base` into `head` on a repo.

  [More info].

  ## Examples

      iex> merge(%Bot{}, "pr-1", "master")
      {201, ""}

  [More info]: https://developer.github.com/v3/repos/merging/
  """
  def merge(bot, head, base) do
    Merges.merge(
      bot.owner,
      bot.name,
      head,
      base,
      "Merge branch '#{base}' into #{head}",
      Client.installation(bot.installation_id)
    )
  end
end
