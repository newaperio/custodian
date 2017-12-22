defmodule Custodian.Bots.BotTest do
  use Custodian.DataCase, async: true

  alias Custodian.Bots.Bot

  @valid_attrs %{
    installation_id: 123,
    name: "gh-api-test",
    owner: "lleger",
    repo_id: 123
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Bot.changeset(%Bot{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Bot.changeset(%Bot{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "validates uniqueness for owner/name" do
    alpha = Bot.changeset(%Bot{}, @valid_attrs)

    bravo =
      Bot.changeset(
        %Bot{},
        Map.put(@valid_attrs, :name, "foo")
      )

    omega = Bot.changeset(%Bot{}, @valid_attrs)

    assert Repo.insert(alpha)
    assert Repo.insert(bravo)
    assert {:error, %Ecto.Changeset{} = changeset} = Repo.insert(omega)
    refute changeset.valid?
    assert changeset.errors[:name] != []
  end

  test "validates uniqueness for repo_id" do
    alpha = Bot.changeset(%Bot{}, @valid_attrs)
    omega = Bot.changeset(%Bot{}, @valid_attrs)

    assert Repo.insert(alpha)
    assert {:error, %Ecto.Changeset{} = changeset} = Repo.insert(omega)
    refute changeset.valid?
    assert changeset.errors[:repo_id] != []
  end
end
