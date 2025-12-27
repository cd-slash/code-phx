defmodule CodingCoordinator.Repo do
  use Ecto.Repo,
    otp_app: :coding_coordinator,
    adapter: Ecto.Adapters.SQLite3
end
