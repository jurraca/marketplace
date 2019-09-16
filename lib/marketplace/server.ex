defmodule Marketplace.Server do 
	use GenServer 

	alias Marketplace.Order 
	alias Marketplace.OrderSupervisor

	def init(_) do
		{:ok, Marketplace.Stash.get()}
	end

	def handle_call({:new, id}, _from, ids) do
		{:ok, _} = OrderSupervisor.add_order(id)
		{:reply, id, [] }
	end	

	def handle_call({:get, id}, _from, state) do
		{:reply, Order.current_state(id), state}
	end

	def handle_call({:get, id, key}, _from, state) do
		{:reply, Order.current_state(id, key), state}
	end	

	def handle_call({:post, key, value, id}, _from, state) do 
		{:reply, Order.post_order(key, value, id), state}
	end

	def handle_call({:match, key, value, id}, _from, state) do 
		{:reply, Order.post_match(key, value, id), state}
	end

	def terminate(_reason, ids) do 
		Marketplace.Stash.update(ids)
	end
end 