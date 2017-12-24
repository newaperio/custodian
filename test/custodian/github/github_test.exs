defmodule Custodian.Github.GithubTest do
  use Custodian.DataCase, async: true

  alias Custodian.Github

  test "process_event/2 returns ok when event is handled" do
    params = %{
      "action" => "created",
      "installation" => %{"id" => 1},
      "repositories" => [%{"full_name" => "lleger/gh-api-test", "id" => 1}]
    }

    assert :ok = Github.process_event("installation", params)
  end

  test "process_event/2 returns error when event is unhandled" do
    assert Github.process_event("nonsense", %{}) == {:error, :unsupported_event}
  end
end
