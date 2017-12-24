defmodule Custodian.Tasks.Async do
  @moduledoc """
  Provides an implmenetation of the `Custodian.Tasks` behaviour.

  This runs the given function asynchronously as a task in the background. This
  is implemented using Elixir's built-in `Task` and returns a PID of the process
  spawned to run the task.
  """
  @behaviour Custodian.Tasks

  @doc """
  Runs `fun` in a task and returns a tuple containing the PID of the task.
  """
  @spec process((() -> any)) :: Custodian.Tasks.result()
  def process(fun) do
    Task.Supervisor.start_child(Custodian.TaskSupervisor, fn ->
      apply(fun, [])
    end)
  end
end
