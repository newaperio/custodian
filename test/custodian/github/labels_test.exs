defmodule Custodian.Github.LabelsTest do
  use ExUnit.Case, async: true

  alias Custodian.Bots.Bot

  @github Application.get_env(:custodian, :github_api)

  @repo {
          %Bot{
            owner: "lleger",
            name: "gh-api-test"
          },
          1
        }

  test "returns list of all labels" do
    assert @github.Labels.all(@repo) == ["needs-review", "in-progress"]
    assert_received :list
  end

  test "adds given label" do
    assert @github.Labels.add(@repo, "ready-to-merge") == @repo
    assert_received {:add, ["ready-to-merge"]}
  end

  test "adds given labels" do
    assert @github.Labels.add(@repo, ["ready-to-merge", "blocked"]) == @repo
    assert_received {:add, ["ready-to-merge", "blocked"]}
  end

  test "doesn't add labels that are already present" do
    labels = ["needs-review", "ready-to-merge"]
    assert @github.Labels.add(@repo, labels) == @repo
    assert_received {:add, ["ready-to-merge"]}
  end

  test "removes given label" do
    assert @github.Labels.remove(@repo, "needs-review") == @repo
    assert_received {:remove, "needs-review"}
  end

  test "doesn't remove label if not applied" do
    assert @github.Labels.remove(@repo, "not-applied") == @repo
    refute_received {:remove, "not-applied"}
  end
end
