defmodule Marketplace do 
	use Application 

	def start(_type, _args) do 
		
		children = [
			Marketplace.Supervisor
		]

		Supervisor.start_link(children, strategy: :one_for_one)
	end 
end