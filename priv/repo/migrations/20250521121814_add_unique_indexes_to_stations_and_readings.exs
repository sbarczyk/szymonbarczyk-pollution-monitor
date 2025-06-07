defmodule Pollutiondb.Repo.Migrations.AddUniqueIndexesToStationsAndReadings do
  use Ecto.Migration

  def change do

    create unique_index(:stations, [:name, :lon, :lat])
    create unique_index(:readings, [:station_id, :date, :time, :type])
  end
end