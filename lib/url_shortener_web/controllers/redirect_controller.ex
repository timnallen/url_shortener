defmodule UrlShortenerWeb.RedirectController do
  use UrlShortenerWeb, :controller

  alias UrlShortener.Urls
  alias UrlShortener.Cache.UrlCache

  def show(conn, %{"short_url" => short_url}) do
    link =
      UrlCache.fetch(short_url, fn ->
        Urls.get_link_by_short_url!(short_url)
      end)

    conn
    |> redirect(external: link.long_url)
  end
end
