defmodule NightingaleWeb.Plugs.Auth do
  import Nightingale.Accounts.Auth, only: [logged_in?: 1, current_user: 1]
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  def init(default), do: default

  def call(conn, _opts) do
    IO.puts("router plug")

    case logged_in?(conn) do
      true ->
        conn
        |> assign(:current_user, current_user(conn))

      _ ->
        conn
        |> put_flash(:error, "You must be logged in to view that page")
        |> redirect(to: "/")
        |> halt()
    end
  end
end

# TODO: We'll want another Plug here to define ownership of accounts etc

defmodule NightingaleWeb.Router do
  use NightingaleWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :login_required do
    plug NightingaleWeb.Plugs.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NightingaleWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/users", UserController, only: [:create, :new]

    # Sessions
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete

    scope "/" do
      pipe_through [:login_required]
      resources "/users", UserController
      scope "/ledger" do
        resources "/accounts", AccountController
      end
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", NightingaleWeb do
  #   pipe_through :api
  # end
end
