defmodule Nightingale.Accounts.Auth do
    alias Nightingale.Accounts.{User, Encryption}

    def login(params, repo) do
        user = repo.get_by(User, email: String.downcase(params["email"]))
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

    @doc """
        current_user_id should only be used after users have been authenticated
        ie: this should be user within routes that have authorization. This does
        not substitute for checking a login and shouldn't be trusted.
    """
    def current_user_id(conn) do
        id = Plug.Conn.get_session(conn, :current_user)
        to_string(id)
    end

    def current_user(conn) do
        id = Plug.Conn.get_session(conn, :current_user)
        if id do
            Nightingale.Repo.get(User, id)
        end
    end

    def logged_in?(conn), do: !!current_user(conn)
end