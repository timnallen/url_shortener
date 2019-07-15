defmodule UrlShortener.Cache.CounterCache do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(
      __MODULE__,
      [
        {:ets_table_name, :counter},
        {:log_limit, 1_000_000}
      ],
      opts
    )
  end

  def update_counter(short_url) do
    GenServer.call(__MODULE__, {:increment, short_url})
  end

  def retrieve_count(short_url) do
    with [{_key, result}] <- GenServer.call(__MODULE__, {:get, short_url}) do
      result
    end
  end

  def handle_call({:get, short_url}, _from, state) do
    %{ets_table_name: ets_table_name} = state
    result = :ets.lookup(ets_table_name, short_url)
    {:reply, result, state}
  end

  def handle_call({:increment, short_url}, _from, state) do
    %{ets_table_name: ets_table_name} = state
    result = :ets.update_counter(ets_table_name, short_url, 1, {0, 0})
    {:reply, result, state}
  end

  def init(args) do
    [{:ets_table_name, ets_table_name}, {:log_limit, log_limit}] = args

    :ets.new(ets_table_name, [:named_table, :set, :private])

    {:ok, %{log_limit: log_limit, ets_table_name: ets_table_name}}
  end
end
