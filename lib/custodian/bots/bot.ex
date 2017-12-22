defmodule Custodian.Bots.Bot do
  @moduledoc """
  A Bot is installed on an individual repo on GitHub. It holds data about its
  repo and installation.

  ## Fields
  - `installation_id` (integer, required) - Integer issued by GitHub for the installation of the app
  - `name` (string, required) - The repo's name
  - `owner` (string, required) - The repo's owner
  - `repo_id` (integer, required) - Integer issued by GitHub identifying the repository

  *Note:* on GitHub, repos are named `owner/name`.

  ## Validations
  - `installation_id` - Required
  - `name` - Required, unique scoped by `owner`
  - `owner` - Required, unique
  - `repo_id` - Required, unique
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Custodian.Bots.Bot

  @typedoc """
  Bot installation on a remote GitHub repository.
  """
  @type t :: %__MODULE__{}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "bots" do
    field(:installation_id, :integer)
    field(:name, :string)
    field(:owner, :string)
    field(:repo_id, :integer)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.

  ## Examples

      iex> changeset(%Bot{}, %{name: "lleger", repo: "gh-api-test"})
      %Ecto.Changeset{}

  """
  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(%Bot{} = bot, attrs) do
    bot
    |> cast(attrs, [:installation_id, :owner, :name, :repo_id])
    |> validate_required([:installation_id, :owner, :name, :repo_id])
    |> unique_constraint(:name, name: :bots_owner_name_index)
    |> unique_constraint(:repo_id)
  end
end
