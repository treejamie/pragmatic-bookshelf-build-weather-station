defmodule Tracker.Sensors.Data do
  use Ecto.Schema
  import Ecto.Changeset

  @allowed_fields [
    :timestamp,
    :altitude_m,
    :pressure_pa,
    :temperature_c,
    :humidity_rh,
    :dew_point_c,
    :gas_resistance_ohms,
    :voc_index,
    :lumens
  ]

  @derive {Jason.Encoder, only: @allowed_fields}
  @primary_key false
  schema "sensor_data" do
    field(:timestamp, :naive_datetime)
    field(:altitude_m, :decimal)
    field(:pressure_pa, :decimal)
    field(:temperature_c, :decimal)
    field(:humidity_rh, :decimal)
    field(:dew_point_c, :decimal)
    field(:gas_resistance_ohms, :decimal)
    field(:voc_index, :decimal)
    field(:lumens, :decimal)
  end

  def create_changeset(data = %__MODULE__{}, attrs) do
    timestamp =
      NaiveDateTime.utc_now()
      |> NaiveDateTime.truncate(:second)

    data
    |> cast(attrs, @allowed_fields)
    |> put_change(:timestamp, timestamp)
    |> validate_required(@allowed_fields)
  end
end
