defmodule UrlShortener.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :short_url, :string
      add :long_url, :string

      timestamps()
    end

    create unique_index(:links, [:short_url])
    create unique_index(:links, [:long_url])
  end
end
