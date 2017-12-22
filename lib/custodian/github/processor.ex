defmodule Custodian.Github.Processor do
  @moduledoc """
  Processing functions for each type of event from GitHub's webhook that we
  respond to.

  Labels are defined according to the NewAperio [spec]. More information can
  be found in the GitHub repo, which includes a programmatic tool for generating
  our standard labels in a repo.

  [spec]: https://github.com/newaperio/github-labels
  """

  alias Custodian.Bots
  alias Custodian.Bots.Bot
  alias Custodian.Repo
  alias Ecto.Multi

  @github Application.get_env(:custodian, :github_api)

  @doc """
  Processes installation events.

  ## Created/Added
  Processes an **installation**. This happens when a user adds the app to one
  or more bots. It iterates over every bot and makes a new record for each.

  ## Deleted
  Processes an **uninstallation**. This happens when a user removes the app
  from a bot. It deletes the given record in the database by its installation
  id.
  """
  @spec installation(map) :: {:ok, [Bot.t()]}
  def installation(%{"action" => "created"} = params) do
    create_bots(params["installation"]["id"], params["repositories"])
  end

  def installation(%{"action" => "added"} = params) do
    create_bots(params["installation"]["id"], params["repositories_added"])
  end

  def installation(%{"action" => "deleted"} = params) do
    bot = Bots.get_bot_by!(installation_id: params["installation"]["id"])
    Bots.delete_bot(bot)
  end

  @doc """
  Processes pull request events.

  ## Opened
  Processes an "opened" pull request.

  - Adds `needs-review` label unless `ready-to-merge`/`in-progress`

  ## Closed
  Processes a **closed** pull request. This is either a merged PR or one that
  was closed manually.

  - Removes all labels
  - Deletes branch

  ## Reopened
  Processes a **reopened** pull request.

  - Removes all labels
  """
  @spec pr(map) :: {:ok, Bot.t()}
  def pr(%{"pull_request" => %{"state" => "open"}} = params) do
    bot = Bots.get_bot_by!(repo_id: params["repository"]["id"])

    labels = @github.Labels.all({bot, params["pull_request"]["number"]})

    if !Enum.member?(labels, "ready-to-merge") && !Enum.member?(labels, "in-progress") do
      @github.Labels.add(
        {bot, params["pull_request"]["number"]},
        "needs-review"
      )
    end

    {:ok, bot}
  end

  def pr(%{"pull_request" => %{"state" => "closed"}} = params) do
    bot = Bots.get_bot_by!(repo_id: params["repository"]["id"])
    branch = params["pull_request"]["head"]["ref"]

    {bot, params["pull_request"]["number"]}
    |> @github.Labels.remove("in-progress")
    |> @github.Labels.remove("needs-review")
    |> @github.Labels.remove("ready-to-merge")

    @github.References.remove(bot, branch)

    {:ok, bot}
  end

  def pr(%{"pull_request" => %{"state" => "reopened"}} = params) do
    bot = Bots.get_bot_by!(repo_id: params["repository"]["id"])

    {bot, params["pull_request"]["number"]}
    |> @github.Labels.remove("in-progress")
    |> @github.Labels.remove("needs-review")
    |> @github.Labels.remove("ready-to-merge")

    {:ok, bot}
  end

  @doc """
  Processes pull request review events.

  ## Approved
  Processes an **approved** pull request review.

  - Removes needs-review and in-progress labels
  - Adds ready-to-merge label
  - Merges changes from the base branch to keep head updated

  ## Changes Requested
  Processes a **changes requested** pull request review.

  - Removes needs-review and ready-to-merge labels
  - Adds in-progress label

  ## Commented
  For reviews that are just **comments**, we ignore the payload and return
  an error. No action is taken.
  """
  @spec review(map) :: {:ok, Bot.t()}
  def review(%{
        "review" => %{"state" => "approved"},
        "pull_request" => pr_params,
        "repository" => %{"id" => repo_id}
      }) do
    bot = Bots.get_bot_by!(repo_id: repo_id)

    {bot, pr_params["number"]}
    |> @github.Labels.remove("needs-review")
    |> @github.Labels.remove("in-progress")
    |> @github.Labels.add("ready-to-merge")

    @github.Merges.merge(
      bot,
      pr_params["head"]["ref"],
      pr_params["base"]["ref"]
    )

    {:ok, bot}
  end

  def review(%{"review" => %{"state" => "changes_requested"}} = params) do
    bot = Bots.get_bot_by!(repo_id: params["repository"]["id"])

    {bot, params["pull_request"]["number"]}
    |> @github.Labels.remove("needs-review")
    |> @github.Labels.remove("ready-to-merge")
    |> @github.Labels.add("in-progress")

    {:ok, bot}
  end

  def review(_params), do: :error

  @spec create_bots(integer, [Bot.t()]) :: {:ok, [Bot.t()]}
  defp create_bots(installation_id, bots) do
    multi =
      Enum.reduce(Enum.with_index(bots), Multi.new(), fn {bot, index}, multi ->
        [owner, name] = bot["full_name"] |> String.split("/")

        Multi.insert(
          multi,
          index,
          Bot.changeset(%Bot{}, %{
            owner: owner,
            name: name,
            repo_id: bot["id"],
            installation_id: installation_id
          })
        )
      end)

    Repo.transaction(multi)
  end
end
