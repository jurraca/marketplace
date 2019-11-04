defmodule Marketplace.OrderSupervisor do 
	use DynamicSupervisor

	@me OrderSupervisor

	def start_link(_) do 
		DynamicSupervisor.start_link(__MODULE__, :no_args, name: @me)
	end 

	def init(:no_args) do 
		DynamicSupervisor.init(strategy: :one_for_one)
	end 

	def start_child({order_name, key, val}) do 
		DynamicSupervisor.start_child(@me, {Marketplace.Order, {order_name, key, val}})
	end 

end