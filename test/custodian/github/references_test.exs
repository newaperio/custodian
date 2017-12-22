defmodule Custodian.Github.ReferencesTest do
  use ExUnit.Case, async: true

  alias Custodian.Bots.Bot

  @github Application.get_env(:custodian, :github_api)

  @repo %Bot{
    owner: "lleger",
    name: "gh-api-test"
  }

  test "deletes a branch" do
    assert @github.References.remove(@repo, "master")
    assert_received {:remove, "master"}
  end
end
