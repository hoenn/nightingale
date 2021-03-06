defmodule Nightingale.Repo.Migrations.CreateUsers do
  use Ecto.Migration
  alias Nightingale.Ledger.Account

  def change do
    create table(:users) do
      add :username, :string
      add :email, :string
      add :password_hash, :string

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
