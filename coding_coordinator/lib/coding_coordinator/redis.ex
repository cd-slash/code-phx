defmodule CodingCoordinator.Redis do
  @moduledoc """
  Redis client wrapper for the coding coordinator.
  """

  use GenServer

  @pool_size 10

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    config = Application.get_env(:coding_coordinator, :redis)

    redix_opts = [
      host: Keyword.fetch!(config, :host),
      port: Keyword.fetch!(config, :port),
      ssl: Keyword.fetch!(config, :ssl),
      database: Keyword.fetch!(config, :database)
    ]

    redix_opts =
      if password = Keyword.get(config, :password) do
        Keyword.put(redix_opts, :password, password)
      else
        redix_opts
      end

    children =
      for i <- 0..(@pool_size - 1) do
        Supervisor.child_spec({Redix, redix_opts}, id: {Redix, i})
      end

    Supervisor.init(children, strategy: :one_for_one)
  end

  def command(command) do
    Redix.command(:redix, command)
  end

  def pipeline(commands) do
    Redix.pipeline(:redix, commands)
  end

  def get(key) do
    command(["GET", key])
  end

  def set(key, value) do
    command(["SET", key, value])
  end

  def set(key, value, expiration) do
    command(["SETEX", key, expiration, value])
  end

  def delete(key) do
    command(["DEL", key])
  end

  def exists?(key) do
    case command(["EXISTS", key]) do
      {:ok, 1} -> true
      {:ok, 0} -> false
      error -> error
    end
  end
end
