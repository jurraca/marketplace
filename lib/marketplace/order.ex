defmodule Marketplace.Order do
	use Agent

	# External 
	def start_link(id) do 
		name = via_tuple(id)
		Agent.start_link(fn -> %{} end, name: name)
	end
	
	def post_order(key, val, id) when is_integer(val) do
		Agent.update(via_tuple(id), 
			fn map -> Map.update(map, key, val, &(&1 + val)) 
		end)
	end

	def post_match(key, val, id) when is_integer(val) do 
		Agent.update(via_tuple(id), 
		 	fn map -> Map.update(map, key, 0, &(&1 - val)) 
		end)
	end

	def current_state(id) do 
		Agent.get(via_tuple(id), & &1)
	end 

	def current_state(id, key) do 
		Agent.get(via_tuple(id), &(Map.get(&1, key)))
	end 

	# Registry lookup 

	defp via_tuple(id) do 
		{:via, Registry, {Marketplace.Registry, id}}
	end 


end