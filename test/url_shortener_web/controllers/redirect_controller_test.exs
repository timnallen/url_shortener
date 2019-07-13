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
end
