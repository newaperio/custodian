defmodule Custodian.Github.MergesTest do
  use ExUnit.Case, async: true

  alias Custodian.Bots.Bot

  @github Application.get_env(:custodian, :github_api)

  @repo %Bot{
    owner: "lleger",
    name: "gh-api-test"
  }

  test "merges head into base" do
    assert @github.Merges.merge(@repo, "lleger-patch-1", "master")
    assert_received {:merge, "lleger-patch-1", "master"}
  end
end
