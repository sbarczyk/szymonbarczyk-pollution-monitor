defmodule Pollutiondb.Station do
  use Ecto.Schema
  alias Pollutiondb.Repo
  require Ecto.Query
  import Ecto.Changeset

  schema "stations" do
    field :name, :string
    field :lon, :float
    field :lat, :float

    has_many :readings, Pollutiondb.Reading
  end

  # Dodawanie gotowej struktury (np. %Station{})
  def add(%__MODULE__{} = station), do: Repo.insert(station)

  # Dodawanie przez podanie wartości z walidacją
  def add(name, lon, lat) do
    case Repo.get_by(__MODULE__, name: name) do
      nil ->
        %__MODULE__{}
        |> changeset(%{name: name, lon: lon, lat: lat})
        |> Repo.insert()

      station ->
        {:ok, station}
    end
  end

  # Aktualizacja nazwy
  def update_name(%__MODULE__{} = station, newname) do
    changeset(station, %{name: newname})
    |> Repo.update()
  end

  def get_all, do: Repo.all(__MODULE__)
  def get_by_id(id), do: Repo.get(__MODULE__, id)
  def remove(station), do: Repo.delete(station)

  def find_by_name(name) do
    query = __MODULE__
            |> Ecto.Query.where([s], like(fragment("lower(?)", s.name), ^"%#{String.downcase(name)}%"))

    Repo.all(query)
  end

  def find_by_location(lon, lat) do
    Ecto.Query.from(s in __MODULE__,
      where: s.lon == ^lon,
      where: s.lat == ^lat
    )
    |> Repo.all()
  end

  def find_by_location_range(lon_min, lon_max, lat_min, lat_max) do
    Ecto.Query.from(s in __MODULE__,
      where: s.lon >= ^lon_min and s.lon <= ^lon_max,
      where: s.lat >= ^lat_min and s.lat <= ^lat_max
    )
    |> Repo.all()
  end


  defp changeset(station, attrs) do
    station
    |> cast(attrs, [:name, :lon, :lat])
    |> validate_required([:name, :lon, :lat])
    |> validate_number(:lon, greater_than_or_equal_to: -180, less_than_or_equal_to: 180)
    |> validate_number(:lat, greater_than_or_equal_to: -90, less_than_or_equal_to: 90)
  end
end