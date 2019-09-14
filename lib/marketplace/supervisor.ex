defmodule Marketplace.Supervisor do 
	use Supervisor 

	def start_link(arg) do 
		Supervisor.start_link(__MODULE__, arg, name: __MODULE__) 
	end

	def init(_init_arg) do
		children = [

			Marketplace.OrderBook
		
		]

		opts = [strategy: :one_for_one]
		
		Supervisor.init(children, opts)
	end 

end 
