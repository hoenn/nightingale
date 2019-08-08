defmodule Nightingale.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :starting_balance, :decimal
      add :name, :string
      add :owner, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:accounts, [:owner])
  end
end
