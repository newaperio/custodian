defmodule Custodian.Github.Mockcat.Labels do
  @behaviour Custodian.Github.Labels

  def all(_) do
    send(self(), :list)

    ["needs-review", "in-progress"]
  end

  def add({repo, pr}, labels) do
    send(self(), {:add, List.wrap(labels)})

    {repo, pr}
  end

  def remove({repo, pr}, label) do
    if Enum.member?(all({repo, pr}), label) do
      send(self(), {:remove, label})
    end

    {repo, pr}
  end
end
