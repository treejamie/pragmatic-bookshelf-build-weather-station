defmodule Publisher do
  @moduledoc """
  Apparently this will be laser focused
  """
  use GenServer
  require Logger

  def start_link(options \\ %{}) do
    GenServer.start_link(__MODULE__, options, name: __MODULE__)
  end

  @impl true
  def init(options) do
    state = %{
      interval: 10_000,
      api_url: options[:api_url],
      sensors: options[:sensors],
      measurements: :no_measurements
    }
  end

  @impl true
  def handle_info(:publish_data, state) do
    {:noreply, state |> measure |> publish}
  end

  defp measure(state) do
    data =
      Enum.reduce(state.sensors, %{}, fn sensor, acc ->
        sensor_data = sensor.read.() |> sensor.convert.()
        Map.merge(acc, data)
      end)

    %{state | measurements: measurements}
  end

  defp publish(state) do
    result =
      Finch.build(
        :post,
        state.api_url,
        [{"Content-Type", "application/json"}],
        JSON.encode!(state.measurements)
      )
      |> Finch.request(TrackerClient)
  end

  defp schedule_publish(interval) do
    Process.send_after(self(), :publish_data, interval)
  end
end
