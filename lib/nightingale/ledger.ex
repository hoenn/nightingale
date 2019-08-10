defmodule Nightingale.Ledger do
  @moduledoc """
  The Ledger context.
  """

  import Ecto.Query, warn: false
  alias Nightingale.Repo

  alias Nightingale.Ledger.Account
  alias Nightingale.Accounts.User

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts do
    Account
    |> Repo.all()
    |> Repo.preload(user: :account)
  end

  def list_user_accounts(%User{}=user) do
    from(a in Account, where: a.user_id == ^user.id)
    |> Repo.all()
    |> Repo.preload(user: :account)
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id) do
    Account
    |> Repo.get!(id)
    |> Repo.preload(user: :account)
  end

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
      account_params
  """
  def create_account(%User{} = user, attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> IO.inspect
    |> Ecto.Changeset.put_change(:user_id, user.id)
    |> IO.inspect
    |> Repo.insert()
  end


  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{source: %Account{}}

  """
  def change_account(%Account{} = account) do
    Account.changeset(account, %{})
  end
end
