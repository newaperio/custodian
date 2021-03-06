defmodule Custodian.Github do
  @moduledoc """
  The GitHub context provides a boundary into the GitHub API client interface
  and associated domain logic. The top-level class provides a way to process
  webhook payloads from GitHub.
  """

  import Ecto.Query, warn: false

  alias Custodian.Github.Processor
  alias Custodian.Tasks

  @typedoc """
  Pull request identifier as a tuple with the repo and integer ID.
  """
  @type pull_request :: {Custodian.Bots.Bot.t(), integer}

  @doc """
  Calls the processing function appropriate for the `type` and `params`.

  ## Events

  Currently, the app responds to the following GitHub webhook [events]:

  - [`installation`]: whenever repos are installed or uninstalled
  - [`installation_repositories`]: whenever repos are added to the installation
  - [`pull_request`]: whenever a pull request is opened or updated
  - [`pull_request_review`]: whenever a pull request review is submitted

  For any other event, it fails.

  ## Examples

      iex> process_event("installation", %{})
      {:ok, [%Bot]}

      iex> process_event("pull_request", %{})
      {:ok, [%Bot]}

  [events]: https://developer.github.com/webhooks/#events
  [`installation`]: https://developer.github.com/v3/activity/events/types/#installationevent
  [`installation_repositories`]: https://developer.github.com/v3/activity/events/types/#installationrepositoriesevent
  [`pull_request`]: https://developer.github.com/v3/activity/events/types/#pullrequestevent
  [`pull_request_review`]: https://developer.github.com/v3/activity/events/types/#pullrequestreviewevent
  """
  @spec process_event(String.t(), map) :: :ok | {:error, atom}
  def process_event(type, params)

  def process_event("installation", params) do
    Tasks.process(fn -> Processor.installation(params) end)
    :ok
  end

  def process_event("installation_repositories", params) do
    Tasks.process(fn -> Processor.installation(params) end)
    :ok
  end

  def process_event("pull_request", params) do
    Tasks.process(fn -> Processor.pr(params) end)
    :ok
  end

  def process_event("pull_request_review", params) do
    Tasks.process(fn -> Processor.review(params) end)
    :ok
  end

  def process_event("repository", params) do
    Tasks.process(fn -> Processor.repo(params) end)
    :ok
  end

  def process_event(_, _) do
    {:error, :unsupported_event}
  end
end
