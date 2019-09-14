defmodule Marketplace.Order do
	use Agent

	# External 
	def start_link do 
		Agent.start_link(fn -> %{} end)
	end
	
	def post_order(key, val, pid) when is_integer(val) do
		Agent.update(pid, 
			fn map -> Map.update(map, key, val, &(&1 + val)) 
		end)
	end

	def post_match(key, val, pid) when is_integer(val) do 
		Agent.update(pid, 
		 	fn map -> Map.update!(map, key, &(&1 - val)) 
		end)
	end

	def current_state(pid) do 
		Agent.get(pid, & &1)
	end 

	def current_state(pid, key) do 
		Agent.get(pid, &(Map.get(&1, key)))
	end 

end