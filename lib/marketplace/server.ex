defmodule Marketplace.Server do 
	use GenServer 

	alias Marketplace.Order 

	def init(pids) do
		{:ok, pids}
	end

	def handle_call(:list, _from, pids) do
		{:reply, pids, pids} 
	end

	def handle_call(:new, _from, pids) do
		{:ok, pid} = Order.start_link
		{:reply, pid, pids ++ [pid] }
	end	

	def handle_call({:get, pid}, _from, state) do
		{:reply, Order.current_state(pid), state}
	end

	def handle_call({:get, pid, key}, _from, state) do
		{:reply, Order.current_state(pid, key), state}
	end	

	def handle_call({:post, key, value, pid}, _from, state) do 
		{:reply, Order.post_order(key, value, pid), state}
	end

	def handle_call({:match, key, value, pid}, _from, state) do 
		{:reply, Order.post_match(key, value, pid), state}
	end

end 