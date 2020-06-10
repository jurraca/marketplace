# Marketplace

This is a set of toy modules for modeling marketplace dynamics in Elixir, mostly to teach myself GenServers and poke around OTP. 
A benefit of looking at the world through Erlang/Elixir is that you can mimick the behavior of individual actors by mapping them to the fundamental computational unit of the BEAM: processes. So an OTP app is a sound choice for building highly concurrent platforms such as an online marketplace. 

The marketplace has several components: 
- `Marketplace.Book`: the public API methods. 
- `Marketplace.Server`: the internal GenServer implementation that validates and routes requests. 
- `Marketplace.Order`: an Agent that holds state. Each agent is supervised by `OrderSupervisor`, a dynamic supervisor. 
- `DemandSimulator` and `SupplySimulator` both generate a stream of supply and demand. (TODO: refine these interfaces). 
- We leverage the `ExSyslogger` library for pushing logs via syslog. 

# Usage 

In the project directory, `iex -S mix` will start the application as `:marketplace`. You can manually launch the Demand & Supply simulators at your leisure.
