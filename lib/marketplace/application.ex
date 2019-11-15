defmodule Marketplace.Application do 
	use Application
	@moduledoc false

	def start(_type, _args) do
		children = [
		#{Registry, [keys: :unique, name: Marketplace.Registry]},
		{Marketplace.Supervisor, []}
		]
		opts = [strategy: :one_for_one, name: Marketplace.AppSupervisor]
		Supervisor.start_link(children, opts)
	end 

end 