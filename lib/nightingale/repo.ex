defmodule Nightingale.Repo do
  use Ecto.Repo,
    otp_app: :nightingale,
    adapter: Ecto.Adapters.Postgres
end
