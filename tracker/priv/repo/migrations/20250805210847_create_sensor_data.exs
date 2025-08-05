defmodule Tracker.Repo.Migrations.CreateSensorData do
  use Ecto.Migration

  def up do
    execute("CREATE EXTENSION IF NOT EXISTS timescaledb")

    create table(:sensor_data, primary_key: false) do
      add(:timestamp, :naive_datetime, null: false)
      add(:altitude_m, :decimal, null: false)
      add(:pressure_pa, :decimal, null: false)
      add(:temperature_c, :decimal, null: false)
      add(:humidity_rh, :decimal, null: false)
      add(:dew_point_c, :decimal, null: false)
      add(:gas_resistance_ohms, :decimal, null: false)
      add(:voc_index, :decimal, null: false)
    end

    execute("SELECT create_hypertable('sensor_data', 'timestamp')")
  end

  def down do
    drop(table(:sensor_data))
    execute("DROP EXTENSION IF EXISTS timescaledb")
  end
end
