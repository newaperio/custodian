defmodule Custodian.Bots do
  @moduledoc """
  The Bots context provides a boundary into the `Custodian.Bots.Bot` schema. It
  provides functions for listing, creating, updating, and deleting bots.
  """

  import Ecto.Query, warn: false
  alias Custodian.Repo

  alias Custodian.Bots.Bot

  @doc """
  Returns the list of bots.

  ## Examples

      iex> list_bots()
      [%Bot{}, ...]

  """
  @spec list_bots :: [Bot.t()]
  def list_bots do
    Repo.all(Bot)
  end

  @doc """
  Gets a single bot.

  Raises `Ecto.NoResultsError` if the bot does not exist.

  ## Examples

      iex> get_bot!(123)
      %Bot{}

      iex> get_bot!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_bot!(String.t()) :: Bot.t()
  def get_bot!(id), do: Repo.get!(Bot, id)

  @doc """
  Gets a single bot by some clause.

  Raises `Ecto.NoResultsError` if the bot does not exist.

  ## Examples

      iex> get_bot_by!(repo_id: 123)
      %Bot{}

      iex> get_bot_by!(repo_id: 456)
      ** (Ecto.NoResultsError)

  """
  @spec get_bot_by!(Keyword.t()) :: Bot.t()
  def get_bot_by!(clauses), do: Repo.get_by!(Bot, clauses)

  @doc """
  Creates a bot.

  ## Examples

      iex> create_bot(%{field: value})
      {:ok, %Bot{}}

      iex> create_bot(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_bot(map) :: Bot.t()
  def create_bot(attrs \\ %{}) do
    %Bot{}
    |> Bot.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a bot.

  ## Examples

      iex> update_bot(bot, %{field: new_value})
      {:ok, %Bot{}}

      iex> update_bot(bot, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_bot(Bot.t(), map) :: Bot.t()
  def update_bot(%Bot{} = bot, attrs) do
    bot
    |> Bot.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Bot.

  ## Examples

      iex> delete_bot(bot)
      {:ok, %Bot{}}

      iex> delete_bot(bot)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_bot(Bot.t()) :: Bot.t()
  def delete_bot(%Bot{} = bot) do
    Repo.delete(bot)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bot changes.

  ## Examples

      iex> change_bot(bot)
      %Ecto.Changeset{source: %Bot{}}

  """
  @spec change_bot(Bot.t()) :: Ecto.Changeset.t()
  def change_bot(%Bot{} = bot) do
    Bot.changeset(bot, %{})
  end
end
