defmodule UrlCacheTest do
  use ExUnit.Case

  alias UrlShortener.Cache.UrlCache

  test "caches and finds the correct data" do
    assert UrlCache.fetch("A", fn ->
             %{id: 1, long_url: "http://www.example.com"}
           end) == %{id: 1, long_url: "http://www.example.com"}

    assert UrlCache.fetch("A", fn -> "" end) == %{
             id: 1,
             long_url: "http://www.example.com"
           }
  end
end
