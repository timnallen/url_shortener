defmodule UrlShortenerWeb.RedirectControllerTest do
  use UrlShortenerWeb.ConnCase

  alias UrlShortener.Urls

  @create_attrs %{
    long_url: "http://example.com/",
    short_url: "some short_url"
  }

  setup %{conn: conn} do
    {:ok, link} = Urls.create_link(@create_attrs)
    {:ok, conn: conn, link: link}
  end

  describe "show" do
    test "redirects to long_url", %{conn: conn, link: link} do
      conn = get(conn, Routes.redirect_path(conn, :show, link.short_url))

      assert redirected_to(conn) =~ link.long_url
    end
  end

  describe "show stats" do
    test "shows stats for short_url", %{conn: conn, link: link} do
      conn = get(conn, Routes.redirect_path(conn, :show, link.short_url))
      conn = get(conn, Routes.redirect_path(conn, :show_stats, link.short_url))

      short = link.short_url
      long = link.long_url

      assert %{
               "short_url" => short,
               "long_url" => long,
               "number_of_times_accessed" => 1
             } = json_response(conn, 200)
    end
  end
end
