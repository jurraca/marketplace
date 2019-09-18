defmodule Marketplace.Server do 
	use GenServer 

	alias Marketplace.Order 
	alias Marketplace.OrderSupervisor

	def init(_) do
		{:ok, Marketplace.Stash.get()}
	end

	def handle_call({:get, id}, _from, state) do
		{:reply, Order.current_state(id), state}
	end

	def handle_call({:get, id, key}, _from, state) do
		lk = order_exists?(id, Order.current_state(id, key), false )
		{:reply, lk, state}
	end	

	def handle_call({:post, key, value, id}, _from, state) do 
		lk = order_exists?(id, 
			Order.post_order(key, value, id), 
			{OrderSupervisor.add_order(id), Order.post_order(key, value, id)}
			)

		{:reply, :ok, state}
	end

	def handle_call({:match, key, value, id}, _from, state) do 
		{:reply, Order.post_match(key, value, id), state}
	end

	def terminate(_reason, ids) do 
		Marketplace.Stash.update(ids)
	end

	defp order_exists?(id, true_func, false_func) do 
		lk = Registry.lookup(Marketplace.Registry, id)
		case lk do 
		[{_pid, _} | _tail] -> true_func 
		[] -> false_func 
		end 
	end
end 