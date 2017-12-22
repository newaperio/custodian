defmodule Custodian.Repo.Migrations.CreateBots do
  use Ecto.Migration

  def change do
    create table(:bots, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:installation_id, :integer)
      add(:name, :string)
      add(:owner, :string)
      add(:repo_id, :integer)

      timestamps()
    end

    create(index(:bots, [:owner, :name], unique: true))
    create(index(:bots, :repo_id, unique: true))
  end
end
