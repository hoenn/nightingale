defmodule Nightingale.Accounts.Auth do
    alias Nightingale.Accounts.{User, Encryption}

    def login(params, repo) do
        user = repo.get_by(User, email: String.downcase(params["email"]))
        case Encryption.validate_password(params["password"], user.password_hash) do
            {:ok, _} -> IO.puts("match")
            _ -> IO.puts("no")
        end
        case authenticate(user, params["password"]) do
            true -> {:ok, user}
            _ -> :error
        end
    end

    defp authenticate(user, password) do
        case user do
            nil -> false
            _ -> Encryption.validate_password(password, user.password_hash)
        end
    end
end