defmodule Nightingale.LedgerTest do
  use Nightingale.DataCase

  alias Nightingale.Ledger

  describe "accounts" do
    alias Nightingale.Ledger.Account

    @valid_attrs %{name: "some name", starting_balance: "120.5"}
    @update_attrs %{name: "some updated name", starting_balance: "456.7"}
    @invalid_attrs %{name: nil, starting_balance: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Ledger.create_account()

      account
    end

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Ledger.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Ledger.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Ledger.create_account(@valid_attrs)
      assert account.name == "some name"
      assert account.starting_balance == Decimal.new("120.5")
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ledger.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Ledger.update_account(account, @update_attrs)
      assert account.name == "some updated name"
      assert account.starting_balance == Decimal.new("456.7")
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Ledger.update_account(account, @invalid_attrs)
      assert account == Ledger.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Ledger.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Ledger.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Ledger.change_account(account)
    end
  end
end
