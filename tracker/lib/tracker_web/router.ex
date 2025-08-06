defmodule TrackerWeb.Router do
  use TrackerWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api/v1", TrackerWeb do
    pipe_through(:api)

    post("/sensor/data", DataController, :create)
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:tracker, :dev_routes) do
    scope "/dev" do
      pipe_through([:fetch_session, :protect_from_forgery])

      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
