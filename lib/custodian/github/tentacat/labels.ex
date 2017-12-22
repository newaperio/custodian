defmodule Custodian.Github.Tentacat.Labels do
  @moduledoc """
  Provides an implementation of the `Custodian.Github.Labels` behaviour with
  the GitHub API.

  This module contains convenience methods for listing, adding, and removing
  labels from GitHub pull requests via the GitHub v3 API over HTTPS.
  """

  @behaviour Custodian.Github.Labels

  alias Custodian.Bots.Bot
  alias Custodian.Github
  alias Custodian.Github.Tentacat.Client

  @doc """
  Returns a list of all of the labels on a given pull request. [More info].

  ## Examples

      iex> all({%Bot{}, 1})
      ["needs-review"]

      iex> all({%Bot{}, 1})
      []

  [More info]: https://developer.github.com/v3/issues/labels/#list-labels-on-an-issue
  """
  @spec all(Github.pull_request()) :: [String.t()]
  def all(pull_request)

  def all({repo, pr}) do
    response =
      Tentacat.Issues.Labels.list(
        repo.owner,
        repo.name,
        pr,
        client(repo)
      )

    Enum.reduce(response, [], fn x, acc -> acc ++ [x["name"]] end)
  end

  @doc """
  Adds the provided label(s) to the given pull request. [More info].

  ## Examples

      iex> add({%Bot{}, 1}, "needs-review")
      {%Bot{}, 1}

      iex> add({%Bot{}, 1}, ["needs-review", "in-progress"])
      {%Bot{}, 1}

  [More info]: https://developer.github.com/v3/issues/labels/#add-labels-to-an-issue
  """
  @spec add(
          Github.pull_request(),
          [String.t()] | String.t()
        ) :: Github.pull_request()
  def add(pull_request, labels)

  def add({repo, pr}, labels) do
    Tentacat.Issues.Labels.add(
      repo.owner,
      repo.name,
      pr,
      List.wrap(labels),
      client(repo)
    )

    {repo, pr}
  end

  @doc """
  Removes a given label from a given pull request. Checks if label is present
  before removing to avoid API errors. [More info].

  ## Examples

      iex> remove({%Bot{}, 1}, "needs-review")
      {%Bot{}, 1}

      iex> remove({%Bot{}, 1}, "in-progress")
      {%Bot{}, 1}

  [More info]: https://developer.github.com/v3/issues/labels/#remove-a-label-from-an-issue
  """
  @spec remove(Github.pull_request(), String.t()) :: Github.pull_request()
  def remove(pull_request, label)

  def remove({repo, pr}, label) do
    if Enum.member?(all({repo, pr}), label) do
      Tentacat.Issues.Labels.remove(
        repo.owner,
        repo.name,
        pr,
        label,
        client(repo)
      )
    end

    {repo, pr}
  end

  @spec client(Bot.t()) :: struct
  defp client(bot) do
    Client.installation(bot.installation_id)
  end
end
