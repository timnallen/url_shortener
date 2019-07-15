defmodule UrlShortenerWeb.RedirectController do
  use UrlShortenerWeb, :controller

  alias UrlShortener.Urls
  alias UrlShortener.Cache.UrlCache
  alias UrlShortener.Cache.CounterCache

  def show(conn, %{"short_url" => short_url}) do
    link =
      UrlCache.fetch(short_url, fn ->
        Urls.get_link_by_short_url!(short_url)
      end)

    CounterCache.update_counter(short_url)

    conn
    |> redirect(external: link.long_url)
  end

  def show_stats(conn, %{"short_url" => short_url}) do
    link =
      UrlCache.fetch(short_url, fn ->
        Urls.get_link_by_short_url!(short_url)
      end)

    count = CounterCache.retrieve_count(short_url)

    stats = %{
      long_url: link.long_url,
      short_url: short_url,
      number_of_times_accessed: count
    }

    json(conn, stats)
  end
end
