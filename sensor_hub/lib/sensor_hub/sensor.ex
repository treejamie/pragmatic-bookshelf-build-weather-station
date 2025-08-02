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

  def fields(BME680),
    do: [
      :altitude_m,
      :pressure_pa,
      :temperature_c,
      :humidity_rh,
      :dew_point_c,
      :gas_resistance_ohms
    ]

  def fields(Veml7700), do: [:light_lumens]

  def read_fn(SGP40) do
    fn -> Process.whereis(:sgp40) |> SGP40.measure() end
  end

  def read_fn(Veml7700), do: fn -> Veml7700.get_measurement() end

  def read_fn(BME680) do
    fn -> Process.whereis(BME680) |> BMP280.measure() end
  end

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
          Map.take(measurement, [
            :altitude_m,
            :pressure_pa,
            :temperature_c,
            :humidity_rh,
            :dew_point_c,
            :gas_resistance_ohms
          ])

        # TODO: fix altitude by correcting for sea level pressure. I am not -146m below sea level

        _ ->
          nil
      end
    end
  end

  def convert_fn(Veml7700) do
    fn reading ->
      %{light_lumens: reading}
    end
  end

  def measure(sensor) do
    sensor.read.()
    |> sensor.convert.()
  end
end
