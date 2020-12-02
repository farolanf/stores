defmodule Stores.Repo do
  use Ecto.Repo,
    otp_app: :stores,
    adapter: Ecto.Adapters.Postgres
end
