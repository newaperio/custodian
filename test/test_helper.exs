if System.get_env("CI") do
  ExUnit.configure(formatters: [JUnitFormatter, ExUnit.CLIFormatter])
end

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Custodian.Repo, :manual)
