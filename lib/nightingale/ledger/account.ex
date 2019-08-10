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

  @required_fields ~w(starting_balance name user)a
  @optional_fields ~w()

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, @required_fields, @optional_fields)
    |> validate_required([:starting_balance, :name, :user])
  end
end
