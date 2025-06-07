defmodule PollutiondbWeb.StationRangeLive do
  use PollutiondbWeb, :live_view

  alias Pollutiondb.Station

  @impl true
  def mount(_params, _session, socket) do
    lat_min = 35.0
    lat_max = 72.0
    lon_min = -25.0
    lon_max = 45.0

    stations = Station.find_by_location_range(lon_min, lon_max, lat_min, lat_max)

    socket =
      assign(socket,
        lat_min: lat_min,
        lat_max: lat_max,
        lon_min: lon_min,
        lon_max: lon_max,
        stations: stations
      )

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gray-50">
      <div class="bg-white shadow">
        <div class="max-w-6xl mx-auto px-4 py-4">
          <div class="flex justify-between items-center">
            <h1 class="text-2xl font-bold text-gray-900">Pollution Monitor</h1>
            <span class="text-sm text-gray-500">Station Range</span>
          </div>
        </div>
      </div>

      <div class="bg-white border-b">
        <div class="max-w-6xl mx-auto px-4">
          <nav class="flex space-x-6 py-3">
            <a href="/" class="px-3 py-2 text-sm font-medium text-gray-600 hover:text-blue-600 rounded">
              Stations
            </a>
            <a href="/range" class="px-3 py-2 text-sm font-medium text-white bg-blue-600 rounded hover:bg-blue-700">
              Station Range
            </a>
            <a href="/readings" class="px-3 py-2 text-sm font-medium text-gray-600 hover:text-blue-600 rounded">
              Readings
            </a>
          </nav>
        </div>
      </div>

      <div class="max-w-6xl mx-auto px-4 py-6">
        <!-- Range Filter -->
        <div class="bg-white rounded-lg shadow border mb-6">
          <div class="p-6">
            <div class="flex items-center mb-4">
              <div class="w-8 h-8 bg-purple-100 rounded flex items-center justify-center mr-3">
                <svg class="w-4 h-4 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 20l-5.447-2.724A1 1 0 013 16.382V5.618a1 1 0 011.447-.894L9 7m0 13l6-3m-6 3V7m6 10l4.553 2.276A1 1 0 0021 18.382V7.618a1 1 0 00-1.447-.894L15 4m0 13V4m-6 3l6-3"></path>
                </svg>
              </div>
              <div>
                <h2 class="text-lg font-semibold text-gray-900">Location Range Filter</h2>
                <p class="text-sm text-gray-600">Adjust the sliders to filter stations by location</p>
              </div>
            </div>

            <form phx-change="update">
              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="space-y-4">
                  <div>
                    <div class="flex justify-between items-center mb-2">
                      <label class="text-sm font-medium text-gray-700">Latitude Min</label>
                      <span class="text-sm bg-gray-100 px-2 py-1 rounded text-gray-600"><%= @lat_min %></span>
                    </div>
                    <input type="range" min="35" max="72" step="0.1" name="lat_min" value={@lat_min}
                           class="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer slider" />
                    <div class="flex justify-between text-xs text-gray-500 mt-1">
                      <span>35°</span>
                      <span>72°</span>
                    </div>
                  </div>

                  <div>
                    <div class="flex justify-between items-center mb-2">
                      <label class="text-sm font-medium text-gray-700">Latitude Max</label>
                      <span class="text-sm bg-gray-100 px-2 py-1 rounded text-gray-600"><%= @lat_max %></span>
                    </div>
                    <input type="range" min="35" max="72" step="0.1" name="lat_max" value={@lat_max}
                           class="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer slider" />
                    <div class="flex justify-between text-xs text-gray-500 mt-1">
                      <span>35°</span>
                      <span>72°</span>
                    </div>
                  </div>
                </div>

                <div class="space-y-4">
                  <div>
                    <div class="flex justify-between items-center mb-2">
                      <label class="text-sm font-medium text-gray-700">Longitude Min</label>
                      <span class="text-sm bg-gray-100 px-2 py-1 rounded text-gray-600"><%= @lon_min %></span>
                    </div>
                    <input type="range" min="-25" max="45" step="0.1" name="lon_min" value={@lon_min}
                           class="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer slider" />
                    <div class="flex justify-between text-xs text-gray-500 mt-1">
                      <span>-25°</span>
                      <span>45°</span>
                    </div>
                  </div>

                  <div>
                    <div class="flex justify-between items-center mb-2">
                      <label class="text-sm font-medium text-gray-700">Longitude Max</label>
                      <span class="text-sm bg-gray-100 px-2 py-1 rounded text-gray-600"><%= @lon_max %></span>
                    </div>
                    <input type="range" min="-25" max="45" step="0.1" name="lon_max" value={@lon_max}
                           class="w-full h-2 bg-gray-200 rounded-lg appearance-none cursor-pointer slider" />
                    <div class="flex justify-between text-xs text-gray-500 mt-1">
                      <span>-25°</span>
                      <span>45°</span>
                    </div>
                  </div>
                </div>
              </div>
            </form>
          </div>
        </div>

        <!-- Filtered Stations -->
        <div class="bg-white rounded-lg shadow border overflow-hidden">
          <div class="px-4 py-3 border-b border-gray-200">
            <div class="flex items-center justify-between">
              <h3 class="text-lg font-semibold text-gray-900">Filtered Stations</h3>
              <span class="text-sm text-gray-500"><%= length(@stations) %> stations found</span>
            </div>
          </div>

          <div class="overflow-x-auto">
            <table class="w-full">
              <thead class="bg-gray-50">
                <tr>
                  <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Name</th>
                  <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Latitude</th>
                  <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Longitude</th>
                  <th class="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
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
                    <td class="px-4 py-3">
                      <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                        In Range
                      </span>
                    </td>
                  </tr>
                <% end %>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>

    <style>
      .slider::-webkit-slider-thumb {
        appearance: none;
        height: 18px;
        width: 18px;
        border-radius: 50%;
        background: #3b82f6;
        cursor: pointer;
        box-shadow: 0 1px 3px rgba(0,0,0,0.2);
      }

      .slider::-moz-range-thumb {
        height: 18px;
        width: 18px;
        border-radius: 50%;
        background: #3b82f6;
        cursor: pointer;
        border: none;
        box-shadow: 0 1px 3px rgba(0,0,0,0.2);
      }
    </style>
    """
  end

  @impl true
  def handle_event("update", params, socket) do
    lat_min = to_float(params["lat_min"], socket.assigns.lat_min)
    lat_max = to_float(params["lat_max"], socket.assigns.lat_max)
    lon_min = to_float(params["lon_min"], socket.assigns.lon_min)
    lon_max = to_float(params["lon_max"], socket.assigns.lon_max)

    stations = Station.find_by_location_range(lon_min, lon_max, lat_min, lat_max)

    socket =
      assign(socket,
        lat_min: lat_min,
        lat_max: lat_max,
        lon_min: lon_min,
        lon_max: lon_max,
        stations: stations
      )

    {:noreply, socket}
  end

  defp to_float(val, default) do
    case Float.parse(val) do
      {v, _} -> v
      _ -> default
    end
  end
end