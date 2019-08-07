defmodule NightingaleWeb.SessionController do
    use NightingaleWeb, :controller

    alias Nightingale.Repo
    alias Nightingale.Accounts.{User, Auth}

    def new(conn, _params) do
        render conn, "new.html"
    end

    def create(conn, session_params) do
        case Auth.login(session_params, Repo) do
            {:ok, user} ->
                conn
                |> put_session(:current_user, user.id)
                |> put_flash(:info, "Logged in")
                |> redirect(to: "/")
            :error ->
                conn
                |> put_flash(:error, "User name or password incorrect")
                |> render("new.html")
        end
    end
end