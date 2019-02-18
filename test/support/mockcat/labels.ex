defmodule Custodian.Github.Mockcat.Labels do
  @behaviour Custodian.Github.Labels

  def all({_, "open"}) do
    send(self(), :list)

    []
  end

  def all({_, "close"}) do
    send(self(), :list)

    ["needs-review", "in-progress", "ready-to-merge"]
  end

  def all({_, "reopen"}) do
    send(self(), :list)

    ["needs-review", "in-progress", "ready-to-merge"]
  end

  def all(_) do
    send(self(), :list)

    ["needs-review", "in-progress"]
  end

  def add({repo, pr}, labels) do
    new_labels = List.wrap(labels) -- all({repo, pr})

    send(self(), {:add, new_labels})

    {repo, pr}
  end

  def remove({repo, pr}, label) do
    if Enum.member?(all({repo, pr}), label) do
      send(self(), {:remove, label})
    end

    {repo, pr}
  end
end
