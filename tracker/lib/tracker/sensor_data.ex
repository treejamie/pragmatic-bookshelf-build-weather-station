defmodule Tracker.Sensors.SensorData do
  alias Tracker.Sensors.Data
  alias Tracker.Repo

  def create_entry(attrs) do
    %Data{}
    |> Data.create_changeset(attrs)
    |> Repo.insert()
  end
end
