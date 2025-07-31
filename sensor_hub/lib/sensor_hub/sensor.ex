defmodule SensorHub.Sensor do
  defstruct [:name, :fields, :read, :convert]

  def new(name) do
    %__MODULE__{
      read: read_fn(name),
      convert: convert_fn(name),
      fields: fields(name),
      name: name
    }
  end

  def fields(SGP40), do: [:voc_index]
  def fields(BME680), do: [:altitude_m, :pressure_pa, :temprature_c]
  def fields(VEML7700), do: [:light_lumens]

  def read_fn(SGP40) do
    fn -> Process.whereis(:sgp40) |> SGP40.measure() end
  end

  def read_fn(BME680), do: fn -> BMP280.measure(BME680) end
  def read_fn(VEML7700), do: fn -> Veml7700.get_measurement() end

  def convert_fn(SGP40) do
    fn reading ->
      case reading do
        {:ok, data} ->
          Map.take(data, [:voc_index])

        _ ->
          %{}
      end
    end
  end

  def convert_fn(BME680) do
    fn reading ->
      case reading do
        {:ok, measurement} ->
          Map.take(measurement, [:altitude, :pressure_pa, :temperature_C])

        _ ->
          %{}
      end
    end
  end

  def convert_fn(VEML7770) do
    fn reading ->
      %{light_lumens: reading}
    end
  end

  def measure(sensor) do
    sensor.read.()
    |> sensor.convert.()
  end
end
