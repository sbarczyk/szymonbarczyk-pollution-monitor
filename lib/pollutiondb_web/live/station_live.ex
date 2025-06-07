defmodule PollutiondbWeb.StationLive do
  use PollutiondbWeb, :live_view

  alias Pollutiondb.Station

  def mount(_params, _session, socket) do
    socket = assign(socket,
      stations: Station.get_all(),
      name: "",
      lat: "",
      lon: "",
      query: ""
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
            <span class="text-sm text-gray-500">Stations</span>
          </div>
        </div>
      </div>

      <div class="bg-white border-b">
        <div class="max-w-6xl mx-auto px-4">
          <nav class="flex space-x-6 py-3">
            <a href="/" class="px-3 py-2 text-sm font-medium text-white bg-blue-600 rounded hover:bg-blue-700">
              Stations
            </a>
            <a href="/range" class="px-3 py-2 text-sm font-medium text-gray-600 hover:text-blue-600 rounded">
              Station Range
            </a>
            <a href="/readings" class="px-3 py-2 text-sm font-medium text-gray-600 hover:text-blue-600 rounded">
              Readings
            </a>
          </nav>
        </div>
      </div>

      <div class="max-w-6xl mx-auto px-4 py-6">
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
          <!-- Create Station -->
          <div class="bg-white rounded-lg shadow border p-6">
            <div class="flex items-center mb-4">
              <div class="w-8 h-8 bg-blue-100 rounded flex items-center justify-center mr-3">
                <svg class="w-4 h-4 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                </svg>
              </div>
              <h2 class="text-lg font-semibold text-gray-900">Create New Station</h2>
            </div>

            <form phx-submit="insert" class="space-y-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Station Name</label>
                <input type="text" name="name" value={@name}
                       class="w-full px-3 py-2 border border-gray-300 rounded focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                       placeholder="Enter station name" />
              </div>

              <div class="grid grid-cols-2 gap-3">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Latitude</label>
                  <input type="number" step="0.1" name="lat" value={@lat}
                         class="w-full px-3 py-2 border border-gray-300 rounded focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                         placeholder="0.0" />
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Longitude</label>
                  <input type="number" step="0.1" name="lon" value={@lon}
                         class="w-full px-3 py-2 border border-gray-300 rounded focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                         placeholder="0.0" />
                </div>
              </div>

              <button type="submit" class="w-full bg-blue-600 text-white py-2 px-4 rounded font-medium hover:bg-blue-700">
                Add Station
              </button>
            </form>
          </div>

          <!-- Search Station -->
          <div class="bg-white rounded-lg shadow border p-6">
            <div class="flex items-center mb-4">
              <div class="w-8 h-8 bg-green-100 rounded flex items-center justify-center mr-3">
                <svg class="w-4 h-4 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                </svg>
              </div>
              <h2 class="text-lg font-semibold text-gray-900">Search Stations</h2>
            </div>

            <form phx-change="search" class="space-y-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Search by Name</label>
                <input type="text" name="query" value={@query}
                       class="w-full px-3 py-2 border border-gray-300 rounded focus:ring-2 focus:ring-green-500 focus:border-green-500"
                       placeholder="Type station name..." />
              </div>
              <div class="text-sm text-gray-500">
                <%= if @query != "", do: "Showing results for: #{@query}", else: "Showing all stations" %>
              </div>
            </form>
          </div>
        </div>

        <!-- Stations Table -->
        <div class="bg-white rounded-lg shadow border overflow-hidden">
          <div class="px-4 py-3 border-b border-gray-200">
            <div class="flex items-center justify-between">
              <h3 class="text-lg font-semibold text-gray-900">Stations List</h3>
              <span class="text-sm text-gray-500"><%= length(@stations) %> stations</span>
            </div>
          </div>

          <div class="overflow-x-auto">
            <table class="w-full">
              <thead class="bg-gray-50">
                <tr>
                  <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Name</th>
                  <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Latitude</th>
                  <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Longitude</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-200">
                <%= for station <- @stations do %>
                  <tr class="hover:bg-gray-50">
                    <td class="px-4 py-3">
                      <div class="flex items-center">
                        <div class="w-2 h-2 bg-green-400 rounded-full mr-2"></div>
                        <span class="text-sm font-medium text-gray-900"><%= station.name %></span>
                      </div>
                    </td>
                    <td class="px-4 py-3 text-sm text-gray-600"><%= station.lat %></td>
                    <td class="px-4 py-3 text-sm text-gray-600"><%= station.lon %></td>
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

  def handle_event("insert", %{"name" => name, "lat" => lat, "lon" => lon}, socket) do
    Station.add(name, to_float(lat, 0.0), to_float(lon, 0.0))

    socket = assign(socket,
      stations: Station.get_all(),
      name: "",
      lat: "",
      lon: ""
    )
    {:noreply, socket}
  end

  def handle_event("search", %{"query" => query}, socket) do
    stations =
      if query == "" do
        Station.get_all()
      else
        Station.find_by_name(query)
      end

    socket = assign(socket, stations: stations, query: query)
    {:noreply, socket}
  end

  defp to_float(val, default) do
    case Float.parse(val) do
      {num, ""} -> num
      _ -> default
    end
  end
end