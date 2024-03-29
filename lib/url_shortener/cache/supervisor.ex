defmodule UrlShortener.Cache.Supervisor do
  use Supervisor

  alias UrlShortener.Cache.UrlCache
  alias UrlShortener.Cache.CounterCache

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(UrlCache, [[name: UrlCache]]),
      worker(CounterCache, [[name: CounterCache]])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
