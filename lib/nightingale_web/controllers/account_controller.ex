defmodule NightingaleWeb.AccountController do
  use NightingaleWeb, :controller

  alias Nightingale.Ledger
  alias Nightingale.Ledger.Account
  alias Nightingale.Accounts.Auth

  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, Auth.current_user(conn).id])
  end

  def index(conn, _params, curr_user) do
    accounts = Ledger.list_user_accounts(curr_user)
    render(conn, "index.html", accounts: accounts)
  end

  def new(conn, _params, curr_user) do
    changeset = Ledger.change_account(%Account{})
    render(conn, "new.html", changeset: changeset)
  end

  defp withUser(acct, u) do
    Map.put(acct, "owner", u)
  end

  def create(conn, %{"account" => account_params}, curr_user) do
    case Ledger.create_account(withUser(account_params, curr_user)) do
      {:ok, account} ->
        conn
        |> put_flash(:info, "Account created successfully.")
        |> redirect(to: Routes.user_account_path(conn, :show, curr_user, account))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, curr_user) do
    IO.puts("show")
    account = Ledger.get_account!(id)
    render(conn, "show.html", account: account)
  end

  def edit(conn, %{"id" => id}, curr_user) do
    account = Ledger.get_account!(id)
    changeset = Ledger.change_account(account)
    render(conn, "edit.html", account: account, changeset: changeset)
  end

  def update(conn, %{"id" => id, "account" => account_params}, curr_user) do
    account = Ledger.get_account!(id)

    case Ledger.update_account(account, account_params) do
      {:ok, account} ->
        conn
        |> put_flash(:info, "Account updated successfully.")
        |> redirect(to: Routes.user_account_path(conn, :show, curr_user, account))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", account: account, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, curr_user) do
    account = Ledger.get_account!(id)
    {:ok, _account} = Ledger.delete_account(account)

    conn
    |> put_flash(:info, "Account deleted successfully.")
    |> redirect(to: Routes.user_account_path(conn, :index, curr_user))
  end
end
