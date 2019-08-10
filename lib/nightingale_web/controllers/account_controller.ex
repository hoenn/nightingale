defmodule NightingaleWeb.AccountController do
  import Plug.Conn

  use NightingaleWeb, :controller

  alias Nightingale.Ledger
  alias Nightingale.Ledger.Account

  plug :authorize_account when action in [:show, :edit, :update, :delete]

  def index(conn, _params) do
    accounts = Ledger.list_user_accounts(conn.assigns.current_user)
    render(conn, "index.html", accounts: accounts)
  end

  def new(conn, _params) do
    changeset = Ledger.change_account(%Account{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"account" => account_params}) do
    case Ledger.create_account(conn.assigns.current_user, account_params) do
      {:ok, account} ->
        conn
        |> put_flash(:info, "Account created successfully.")
        |> redirect(to: Routes.account_path(conn, :show, account))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    account = Ledger.get_account!(id)
    render(conn, "show.html", account: account)
  end

  def edit(conn, _) do
    changeset = Ledger.change_account(conn.assigns.account)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"account" => account_params}) do

    case Ledger.update_account(conn.assigns.account, account_params) do
      {:ok, account} ->
        conn
        |> put_flash(:info, "Account updated successfully.")
        |> redirect(to: Routes.account_path(conn, :show, account))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, _) do
    {:ok, _account} = Ledger.delete_account(conn.assigns.account)

    conn
    |> put_flash(:info, "Account deleted successfully.")
    |> redirect(to: Routes.account_path(conn, :index))
  end

  defp authorize_account(conn, _) do
    account = Ledger.get_account!(conn.params["id"])
    if conn.assigns.current_user.id == account.user_id do
      assign(conn, :account, account)
    else
      conn
      |> put_flash(:error, "You do not have permission to view that page")
      |> redirect(to: Routes.account_path(conn, :index))
      |> halt()
    end
  end
end
