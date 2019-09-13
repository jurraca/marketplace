defmodule Marketplace.Order do
	use Agent

	# External 
	def start_link do 
		Agent.start_link(fn -> %{small: 0, medium: 0, large: 0} end)
	end
	
	def post_order(type, size, pid) do
		Agent.update(pid, 
			fn map -> Map.update(map, type, size, &(&1 + size)) 
		end)
	end

	def post_match(type, size, pid) do
		Agent.update(pid, fn map -> Map.update(map, type, size, &(&1 - size))
		end) 
	end

	def current_state([]), do: [] 

	def current_state([head | tail]) do 
		current_state([head | current_state(tail)])
	end 

	def current_state(pid) do 
		Agent.get(pid, & &1)
	end 

	def current_state(pid, type) do 
		Agent.get(pid, &(Map.get(&1, type)))
	end 

end