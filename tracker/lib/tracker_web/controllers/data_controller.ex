defmodule TrackerWeb.DataController do
  use TrackerWeb, :controller
  require Logger

  alias Tracker.Sensors.SensorData

  @doc """
  This is a learning exercise and there's no validation of user
  input. Obviously that's not how you'd do it in production.

  """
  def create(conn, params) do
    IO.inspect(params)

    case(SensorData.create_entry(params)) do
      {:ok, data} ->
        Logger.debug("Success: done a data")

        conn
        |> put_status(:created)
        |> json(data)

      {:error, changeset} ->
        Logger.warning("Fail: didn't make a data: #{inspect(changeset)}")

        conn
        |> put_status(:unprocessable_entity)
        |> json(%{message: "poorly formatted payload"})
    end
  end
end
