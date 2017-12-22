defmodule CustodianWeb.Router do
  use CustodianWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", CustodianWeb do
    pipe_through(:api)

    post("/__webhook", WebhookController, :receive)
  end
end
