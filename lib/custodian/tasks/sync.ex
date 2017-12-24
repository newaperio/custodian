defmodule Custodian.Tasks.Sync do
  @moduledoc """
  Provides an implmenetation of the `Custodian.Tasks` behaviour.

  This runs the given function inline, immediately processing the task and
  returning the result.
  """
  @behaviour Custodian.Tasks

  @doc """
  Runs `fun` inline and returns the result immediately.
  """
  @spec process((() -> any)) :: any
  def process(fun) do
    apply(fun, [])
  end
end
