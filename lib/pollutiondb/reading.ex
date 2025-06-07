defmodule Pollutiondb.Reading do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pollutiondb.{Repo, Station}
  require Ecto.Query

  schema "readings" do
    field :date, :date
    field :time, :time
    field :type, :string
    field :value, :float

    belongs_to :station, Station

    timestamps()
  end

  # Funkcja zwracająca 10 najnowszych odczytów
  def last_readings() do
    Ecto.Query.from(r in __MODULE__,
      limit: 10,
      order_by: [desc: r.date, desc: r.time],
      preload: [:station]
    )
    |> Repo.all()
  end

  # Funkcja zwracająca 10 najnowszych odczytów dla konkretnej daty
  def readings_by_date(date) do
    Ecto.Query.from(r in __MODULE__,
      where: r.date == ^date,
      limit: 10,
      order_by: [desc: r.time],
      preload: [:station]
    )
    |> Repo.all()
  end

  def add(%Station{id: station_id}, date, time, type, value) do
    existing = Repo.get_by(__MODULE__, station_id: station_id, date: date, time: time, type: type)

    if existing do
      {:error, :duplicate}
    else
      %__MODULE__{}
      |> changeset(%{date: date, time: time, type: type, value: value, station_id: station_id})
      |> Repo.insert()
    end
  end

  def add_now(%Station{id: station_id}, type, value) do
    %__MODULE__{}
    |> changeset(%{
      date: Date.utc_today(),
      time: Time.utc_now() |> Time.truncate(:second),
      type: type,
      value: value,
      station_id: station_id
    })
    |> Repo.insert()
  end


  def find_by_date(date) do
    __MODULE__
    |> Ecto.Query.where(date: ^date)
    |> Repo.all()
  end


  defp changeset(reading, attrs) do
    reading
    |> cast(attrs, [:date, :time, :type, :value, :station_id])
    |> validate_required([:date, :time, :type, :value, :station_id])
    |> validate_number(:value, greater_than_or_equal_to: 0)
  end
end