defmodule UrlShortener.Cache.UrlCache do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(
      __MODULE__,
      [
        {:ets_table_name, :url_cache_table},
        {:log_limit, 1_000_000}
      ],
      opts
    )
  end

  def fetch(short_url, default_value_function) do
    case get(short_url) do
      {:not_found} -> set(short_url, default_value_function.())
      {:found, result} -> result
    end
  end

  defp get(short_url) do
    case GenServer.call(__MODULE__, {:get, short_url}) do
      [] -> {:not_found}
      [{_short_url, result}] -> {:found, result}
    end
  end

  defp set(short_url, value) do
    GenServer.call(__MODULE__, {:set, short_url, value})
  end

  # GenServer callbacks

  def handle_call({:get, short_url}, _from, state) do
    %{ets_table_name: ets_table_name} = state
    result = :ets.lookup(ets_table_name, short_url)
    {:reply, result, state}
  end

  def handle_call({:set, short_url, value}, _from, state) do
    %{ets_table_name: ets_table_name} = state
    true = :ets.insert(ets_table_name, {short_url, value})
    {:reply, value, state}
  end

  def init(args) do
    [{:ets_table_name, ets_table_name}, {:log_limit, log_limit}] = args

    :ets.new(ets_table_name, [:named_table, :set, :private])

    {:ok, %{log_limit: log_limit, ets_table_name: ets_table_name}}
  end
end
