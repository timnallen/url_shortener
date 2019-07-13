defmodule UrlShortenerWeb.RedirectController do
  use UrlShortenerWeb, :controller

  alias UrlShortener.Urls

  def show(conn, %{"short_url" => short_url}) do
    link = Urls.get_link_by_short_url!(short_url)

    conn
    |> redirect(external: link.long_url)
  end
end
