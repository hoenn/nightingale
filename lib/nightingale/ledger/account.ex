defmodule Nightingale.Ledger.Account do
  use Ecto.Schema
  import Ecto.Changeset
  alias Nightingale.Accounts.User

  schema "accounts" do
    field :name, :string
    field :starting_balance, :decimal

    belongs_to :user, User
    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :starting_balance])
    |> validate_required([:starting_balance, :name])
  end
end
