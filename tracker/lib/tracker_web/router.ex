defmodule TrackerWeb.Router do
  use TrackerWeb, :router

  pipeline :api do
    #
    # NOTE: This is an API endpoint and in a real production setting
    # I'd have ensure there were one or more plugs to handle authentication
    # and authorisation.
    # But this is learning land and so there's bok all.
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
