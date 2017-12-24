defmodule Custodian.Tasks do
  @moduledoc """
  Behaviour interface for processing tasks.

  Tasks are encapsulated segments of work that need to be done. They can be
  processed in the background by spawning a new process or synchronously by
  running inline.
  """

  @processor Application.get_env(:custodian, :processor)

  @typedoc """
  Tuple containing an atom indicating successful startup and the PID of the
  process running the test. Otherwise, returns an error tuple.
  """
  @type result :: {:ok, pid} | any

  @doc """
  Takes a function and runs the task according to the implementation. Returns
  a success or error tuple.
  """
  @callback process(fun :: (() -> any)) :: result

  @doc """
  Runs the given function as a task

  This runs `fun` as a task according to the configured processor. For most
  environments, this is asynchronous: a new process is spawned and supervised
  by the app. For some environments, like `test`, this is inline.
  """
  @spec process((() -> any)) :: result
  def process(fun) do
    @processor.process(fun)
  end
end
