defmodule Custodian.Github.ProcessorTest do
  use Custodian.DataCase, async: true

  alias Custodian.Bots
  alias Custodian.Github.Processor

  test "inserts repo on create" do
    params = %{
      "action" => "created",
      "installation" => %{"id" => 1},
      "repositories" => [
        %{
          "full_name" => "lleger/gh-api-test",
          "id" => 1
        }
      ]
    }

    {:ok, bots} = Processor.installation(params)
    {_, bot} = Enum.at(bots, 0)

    assert map_size(bots) == 1
    assert bot.owner == "lleger"
    assert bot.name == "gh-api-test"
    assert bot.installation_id == 1
    assert bot.repo_id == 1
  end

  test "inserts multiple repos on add" do
    params = %{
      "action" => "added",
      "installation" => %{"id" => 1},
      "repositories_added" => [
        %{
          "full_name" => "lleger/gh-api-test",
          "id" => 1
        },
        %{
          "full_name" => "lleger/hello-world",
          "id" => 2
        }
      ]
    }

    {:ok, bots} = Processor.installation(params)
    {_, bot_alpha} = Enum.at(bots, 0)
    {_, bot_omega} = Enum.at(bots, 1)

    assert map_size(bots) == 2
    assert bot_alpha.owner == "lleger"
    assert bot_alpha.name == "gh-api-test"
    assert bot_alpha.installation_id == 1
    assert bot_alpha.repo_id == 1
    assert bot_omega.owner == "lleger"
    assert bot_omega.name == "hello-world"
    assert bot_omega.installation_id == 1
    assert bot_omega.repo_id == 2
  end

  test "deletes repo on delete" do
    Bots.create_bot(%{
      repo_id: 1,
      owner: "lleger",
      name: "gh-api-test",
      installation_id: 1
    })

    params = %{
      "action" => "removed",
      "installation" => %{"id" => 1}
    }

    assert {:ok, bot} = Processor.installation(params)
    assert_raise Ecto.NoResultsError, fn -> Bots.get_bot!(bot.id) end
  end

  test "labels pr when opened" do
    Bots.create_bot(%{
      repo_id: 1,
      owner: "lleger",
      name: "gh-api-test",
      installation_id: 1
    })

    params = %{
      "repository" => %{
        "id" => 1
      },
      "pull_request" => %{
        "number" => "open",
        "state" => "open"
      }
    }

    assert {:ok, bot} = Processor.pr(params)
    assert_received {:add, ["needs-review"]}
  end

  test "labels draft pr when opened" do
    Bots.create_bot(%{
      repo_id: 1,
      owner: "lleger",
      name: "gh-api-test",
      installation_id: 1
    })

    params = %{
      "repository" => %{
        "id" => 1
      },
      "pull_request" => %{
        "number" => "open",
        "state" => "open",
        "draft" => true
      }
    }

    assert {:ok, bot} = Processor.pr(params)
    assert_received {:add, ["in-progress"]}
  end

  test "labels pr when closed" do
    Bots.create_bot(%{
      repo_id: 1,
      owner: "lleger",
      name: "gh-api-test",
      installation_id: 1
    })

    params = %{
      "repository" => %{
        "id" => 1
      },
      "pull_request" => %{
        "number" => "close",
        "state" => "closed"
      }
    }

    assert {:ok, bot} = Processor.pr(params)
    assert_received {:remove, "needs-review"}
    assert_received {:remove, "in-progress"}
    assert_received {:remove, "ready-to-merge"}
  end

  test "labels pr when reopened" do
    Bots.create_bot(%{
      repo_id: 1,
      owner: "lleger",
      name: "gh-api-test",
      installation_id: 1
    })

    params = %{
      "repository" => %{
        "id" => 1
      },
      "pull_request" => %{
        "number" => "reopen",
        "state" => "closed"
      }
    }

    assert {:ok, bot} = Processor.pr(params)
    assert_received {:remove, "needs-review"}
    assert_received {:remove, "in-progress"}
    assert_received {:remove, "ready-to-merge"}
  end
end
