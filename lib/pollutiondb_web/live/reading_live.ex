defmodule PollutiondbWeb.ReadingLive do
  use PollutiondbWeb, :live_view

  alias Pollutiondb.{Reading, Station}

  def mount(_params, _session, socket) do
    today = Date.utc_today()
    stations = Station.get_all()

    socket =
      assign(socket,
        date: today,
        readings: Reading.last_readings(),
        stations: stations,
        station_id: (if Enum.any?(stations), do: hd(stations).id, else: nil),
        type: "",
        value: ""
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gray-50">
      <div class="bg-white shadow">
        <div class="max-w-6xl mx-auto px-4 py-4">
          <div class="flex justify-between items-center">
            <h1 class="text-2xl font-bold text-gray-900">Pollution Monitor</h1>
            <span class="text-sm text-gray-500">Readings</span>
          </div>
        </div>
      </div>

      <div class="bg-white border-b">
        <div class="max-w-6xl mx-auto px-4">
          <nav class="flex space-x-6 py-3">
            <a href="/" class="px-3 py-2 text-sm font-medium text-gray-600 hover:text-blue-600 rounded">
              Stations
            </a>
            <a href="/range" class="px-3 py-2 text-sm font-medium text-gray-600 hover:text-blue-600 rounded">
              Station Range
            </a>
            <a href="/readings" class="px-3 py-2 text-sm font-medium text-white bg-blue-600 rounded hover:bg-blue-700">
              Readings
            </a>
          </nav>
        </div>
      </div>

      <div class="max-w-6xl mx-auto px-4 py-6">
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
          <!-- Search by date -->
          <div class="bg-white rounded-lg shadow border p-6">
            <div class="flex items-center mb-4">
              <div class="w-8 h-8 bg-blue-100 rounded flex items-center justify-center mr-3">
                <svg class="w-4 h-4 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                </svg>
              </div>
              <h2 class="text-lg font-semibold text-gray-900">Search Readings by Date</h2>
            </div>

            <form phx-submit="search" class="space-y-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Date</label>
                <input type="date" name="date" value={@date}
                       class="w-full px-3 py-2 border border-gray-300 rounded focus:ring-2 focus:ring-blue-500 focus:border-blue-500" />
              </div>
              <button type="submit" class="w-full bg-blue-600 text-white py-2 px-4 rounded font-medium hover:bg-blue-700">
                Search
              </button>
            </form>
          </div>

          <!-- Insert new reading -->
          <div class="bg-white rounded-lg shadow border p-6">
            <div class="flex items-center mb-4">
              <div class="w-8 h-8 bg-green-100 rounded flex items-center justify-center mr-3">
                <svg class="w-4 h-4 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                </svg>
              </div>
              <h2 class="text-lg font-semibold text-gray-900">Add New Reading</h2>
            </div>

            <form phx-submit="insert" class="space-y-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Station</label>
                <select name="station_id" class="w-full px-3 py-2 border border-gray-300 rounded focus:ring-2 focus:ring-green-500 focus:border-green-500">
                  <%= for station <- @stations do %>
                    <option value={station.id} selected={station.id == @station_id}><%= station.name %></option>
                  <% end %>
                </select>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Type</label>
                <input type="text" name="type" value={@type}
                       class="w-full px-3 py-2 border border-gray-300 rounded focus:ring-2 focus:ring-green-500 focus:border-green-500"
                       placeholder="Enter reading type" />
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Value</label>
                <input type="number" step="0.1" name="value" value={@value}
                       class="w-full px-3 py-2 border border-gray-300 rounded focus:ring-2 focus:ring-green-500 focus:border-green-500"
                       placeholder="0.0" />
              </div>

              <button type="submit" class="w-full bg-green-600 text-white py-2 px-4 rounded font-medium hover:bg-green-700">
                Add Reading
              </button>
            </form>
          </div>
        </div>

        <!-- Display readings -->
        <div class="bg-white rounded-lg shadow border overflow-hidden">
          <div class="px-4 py-3 border-b border-gray-200">
            <div class="flex items-center justify-between">
              <h3 class="text-lg font-semibold text-gray-900">Readings List</h3>
              <span class="text-sm text-gray-500"><%= length(@readings) %> readings</span>
            </div>
          </div>

          <div class="overflow-x-auto">
            <table class="w-full">
              <thead class="bg-gray-50">
                <tr>
                  <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Station</th>
                  <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Date</th>
                  <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Time</th>
                  <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Type</th>
                  <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Value</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-200">
                <%= for reading <- @readings do %>
                  <tr class="hover:bg-gray-50">
                    <td class="px-4 py-3">
                      <div class="flex items-center">
                        <div class="w-2 h-2 bg-blue-400 rounded-full mr-2"></div>
                        <span class="text-sm font-medium text-gray-900"><%= reading.station.name %></span>
                      </div>
                    </td>
                    <td class="px-4 py-3 text-sm text-gray-600"><%= reading.date %></td>
                    <td class="px-4 py-3 text-sm text-gray-600"><%= reading.time %></td>
                    <td class="px-4 py-3 text-sm text-gray-600"><%= reading.type %></td>
                    <td class="px-4 py-3 text-sm text-gray-600"><%= reading.value %></td>
                  </tr>
                <% end %>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("search", %{"date" => date_str}, socket) do
    readings = if date_str == "" do
      Reading.last_readings()
    else
      date = to_date(date_str)
      Reading.readings_by_date(date)
    end

    {:noreply, assign(socket, date: to_date(date_str), readings: readings)}
  end

  def handle_event("insert", %{"station_id" => station_id, "type" => type, "value" => value}, socket) do
    station = %Station{id: to_int(station_id, 1)}
    Reading.add_now(station, type, to_float(value, 0.0))
    {:noreply, assign(socket, readings: Reading.last_readings(), type: "", value: "", station_id: station.id)}
  end

  defp to_date(""), do: Date.utc_today()

  defp to_date(str) do
    case Date.from_iso8601(str) do
      {:ok, date} -> date
      _ -> Date.utc_today()
    end
  end

  defp to_int(str, default) do
    case Integer.parse(str) do
      {val, ""} -> val
      _ -> default
    end
  end

  defp to_float(str, default) do
    case Float.parse(str) do
      {val, ""} -> val
      _ -> default
    end
  end
end