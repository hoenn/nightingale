defmodule Nightingale.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Nightingale.Accounts.{User, Encryption}
  alias Nightingale.Ledger.Account


  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :username, :string

    has_many :accounts, Account

    ## Virtual fields
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @required_fields ~w(email username password)a
  @optional_fields ~w()

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, @required_fields, @optional_fields)
    |> validate_required([:username, :email])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password)
    |> downcase_email
    |> unique_constraint(:email)
    |> encrypt_password
  end

  defp downcase_email(changeset) do
    email = get_change(changeset, :email)

    if email do
      email_lower = String.downcase(email)
      put_change(changeset, :email, email_lower)
    else
      changeset
    end
  end

  defp encrypt_password(changeset) do
    password = get_change(changeset, :password)

    if password do
      encrypted_password = Encryption.hash_password(password)
      put_change(changeset, :password_hash, encrypted_password)
    else
      changeset
    end
  end
end
