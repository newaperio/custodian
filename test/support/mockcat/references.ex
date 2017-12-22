defmodule Custodian.Github.Mockcat.References do
  @behaviour Custodian.Github.References

  def remove(_, branch) do
    send(self(), {:remove, branch})

    {204, :ok}
  end
end
