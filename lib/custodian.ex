defmodule Custodian do
  @moduledoc """
  **Custodian** is a GitHub bot to manage routine development tasks. At a
  high-level it attempts to do the following:

  - Manage labels on pull requests based on their state
  - Delete branches after pull requests are merged

  This is the top-level module that holds the domain and business logic to
  achieve these goals. The web API leverages this namespace to process events
  from GitHub webhooks.
  """
end
