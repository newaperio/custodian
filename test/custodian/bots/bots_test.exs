defmodule Custodian.BotsTest do
  use Custodian.DataCase, async: true

  alias Custodian.Bots
  alias Custodian.Bots.Bot

  @valid_attrs %{
    repo_id: 42,
    owner: "lleger",
    name: "gh-api-test",
    installation_id: 42
  }
  @update_attrs %{
    repo_id: 43,
    owner: "newaperio",
    name: "gh-api-test-1",
    installation_id: 43
  }
  @invalid_attrs %{
    repo_id: nil,
    owner: "",
    name: "",
    installation_id: nil
  }

  def bot_fixture(attrs \\ %{}) do
    {:ok, bot} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Bots.create_bot()

    bot
  end

  test "list_bots/0 returns all bots" do
    bot = bot_fixture()
    assert Bots.list_bots() == [bot]
  end

  test "get_bot!/1 returns the bot with given id" do
    bot = bot_fixture()
    assert Bots.get_bot!(bot.id) == bot
  end

  test "get_repo_by!/1 returns the repo with given repo_id" do
    bot = bot_fixture()
    assert Bots.get_bot_by!(repo_id: 42) == bot
  end

  test "get_repo_by!/1 returns the repo with given installation_id" do
    bot = bot_fixture()
    assert Bots.get_bot_by!(installation_id: 42) == bot
  end

  test "create_bot/1 with valid data creates a bot" do
    assert {:ok, %Bot{} = bot} = Bots.create_bot(@valid_attrs)
    assert bot.installation_id == 42
    assert bot.name == "gh-api-test"
    assert bot.owner == "lleger"
    assert bot.repo_id == 42
  end

  test "create_bot/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Bots.create_bot(@invalid_attrs)
  end

  test "update_bot/2 with valid data updates the bot" do
    bot = bot_fixture()
    assert {:ok, bot} = Bots.update_bot(bot, @update_attrs)
    assert %Bot{} = bot
    assert bot.installation_id == 43
    assert bot.name == "gh-api-test-1"
    assert bot.owner == "newaperio"
    assert bot.repo_id == 43
  end

  test "update_bot/2 with invalid data returns error changeset" do
    bot = bot_fixture()
    assert {:error, %Ecto.Changeset{}} = Bots.update_bot(bot, @invalid_attrs)
    assert bot == Bots.get_bot!(bot.id)
  end

  test "delete_bot/1 deletes the bot" do
    bot = bot_fixture()
    assert {:ok, %Bot{}} = Bots.delete_bot(bot)
    assert_raise Ecto.NoResultsError, fn -> Bots.get_bot!(bot.id) end
  end

  test "change_bot/1 returns a bot changeset" do
    bot = bot_fixture()
    assert %Ecto.Changeset{} = Bots.change_bot(bot)
  end
end
