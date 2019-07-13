defmodule UrlShortenerWeb.Router do
  use UrlShortenerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", UrlShortenerWeb do
    pipe_through :api

    resources "/links", LinkController
  end

  scope "/", UrlShortenerWeb do
    match(:get, "/:short_url", RedirectController, :show)
  end
end
