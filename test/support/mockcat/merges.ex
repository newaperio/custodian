defmodule Custodian.Github.Mockcat.Merges do
  def merge(_, head, base) do
    send(self(), {:merge, head, base})

    {204, :ok}
  end
end
