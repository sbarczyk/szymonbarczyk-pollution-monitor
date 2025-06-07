defmodule PollutionDataLoader do
  @moduledoc """
  Moduł do wczytywania danych z pliku CSV i rejestracji stacji oraz pomiarów
  w GenServerze `:pollution_gen_server`.
  """

  @type reading :: %{
                     datetime: {{integer, integer, integer}, {integer, integer, integer}},
                     stationId: integer,
                     stationName: String.t(),
                     location: {float, float},
                     pollutionType: String.t(),
                     pollutionLevel: float
                   }

  @doc """
  Wczytuje wszystkie wiersze z pliku i parsuje je na listę struktur `reading`.
  """
  @spec extract_readings(String.t()) :: [reading]
  def extract_readings(path) do
    File.read!(path)
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  @doc """
  Z listy odczytów wyciąga unikalne stacje (po `stationId`).
  """
  @spec extract_stations([reading]) :: [%{stationId: integer, stationName: String.t(), location: {float, float}}]
  def extract_stations(readings) do
    readings
    |> Enum.uniq_by(& &1.stationId)
    |> Enum.map(fn %{stationId: id, stationName: name, location: coord} ->
      %{stationId: id, stationName: name, location: coord}
    end)
  end

  @doc """
  Rejestruje listę stacji w GenServerze, budując nazwę `"ID Nazwa"`.
  """
  @spec load_stations([%{stationId: integer, stationName: String.t(), location: {float, float}}]) :: map
  def load_stations(stations) do
    Enum.reduce(stations, %{}, fn %{stationId: id, stationName: name, location: {lat, lon}}, acc ->
      case Pollutiondb.Station.add(name, lon, lat) do
        {:ok, station} -> Map.put(acc, id, station)
        {:error, reason} ->
          IO.puts("Błąd podczas dodawania stacji: #{inspect(reason)}")
          acc
      end
    end)
  end

  @spec load_measurements([reading], map) :: :ok
  def load_measurements(readings, station_map) do
    Enum.each(readings, fn %{
                             stationId: id,
                             datetime: {{year, month, day}, {hour, minute, second}},
                             pollutionType: type,
                             pollutionLevel: lvl
                           } ->
      with %Pollutiondb.Station{} = station <- Map.get(station_map, id),
           {:ok, date} <- Date.new(year, month, day),
           {:ok, time} <- Time.new(hour, minute, second, 0) do
        Pollutiondb.Reading.add(station, date, time, type, lvl)
      end
    end)

    :ok
  end

  # ——— Funkcje pomocnicze ———

  defp parse_line(line) do
    [datetime, type, value, id, name, loc] = String.split(line, ";")
    {lat, lon} = parse_location(loc)

    %{
      datetime:       parse_datetime(datetime),
      stationId:      String.to_integer(id),
      stationName:    name,
      location:       {lat, lon},
      pollutionType:  type,
      pollutionLevel: String.to_float(value)
    }
  end

  defp parse_datetime(str) do
    [date, time_z] = String.split(str, "T")
    time = String.slice(time_z, 0..7)

    {
      date
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple(),
      time
      |> String.split(":")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    }
  end

  defp parse_location(str) do
    [lat, lon] =
      str
      |> String.split(",")
      |> Enum.map(&String.to_float/1)

    {lat, lon}
  end
end