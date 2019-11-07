# Marketplace

The marketplace has several components: 
- `Marketplace.Book`: the public API methods. 
- `Marketplace.Server`: the internal GenServer implementation that validates and routes requests. 
- `Marketplace.Order`: an Agent that holds state. Each agent is supervised by `OrderSupervisor`, a dynamic supervisor. 
- `DemandSimulator` and `SupplySimulator` both generate a stream of supply and demand. (TODO: refine these interfaces). 
- We leverage the `ExSyslogger` library for pushing logs via syslog. 

# Usage 

In the project directory, `iex -S mix`. 
`{:ok, sup} = Marketplace.Supervisor.start_link([])` to start the Supervisor and associated children. 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `marketplace` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:marketplace, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/marketplace](https://hexdocs.pm/marketplace).

