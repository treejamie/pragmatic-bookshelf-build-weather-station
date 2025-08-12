defmodule SensorHub do
  @moduledoc """
  Documentation for `SensorHub`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> SensorHub.hello()
      :world

  """

  def read() do
    Map.merge(
      # VEML
      SensorHub.Sensor.new(Veml770) |> SensorHub.Sensor.measure(),

      # SGP40
      SensorHub.Sensor.new(BME680) |> SensorHub.Sensor.measure()
    )
    |> Map.merge(
      # BME680
      SensorHub.Sensor.new(SGP40) |> SensorHub.Sensor.measure()
    )
  end
end
