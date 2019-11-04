defmodule Marketplace.Order do
	use Agent

	# External 
	def start_link({id, key, val}) do 
		Agent.start_link(fn -> %{key => val} end, name: via_tuple(id))
	end
	
	def post_order(key, val, id) when is_integer(val) do
		Agent.update(via_tuple(id), 
			fn map -> Map.update(map, key, val, &(&1 + val)) 
		end)
	end

	def post_match(key, val, id) when is_integer(val) do 
		fun = case current_state(id, key) - val > 0 do
			true -> &(&1 - val)
			false -> &(&1 * 0) # 0 if the match overshoots. ie fill all you can, but don't return non-matches
			end
		Agent.update(via_tuple(id), 
		 	fn map -> Map.update(map, key, 0, fun) end )
	end
 
	def current_state(id) do 
		Agent.get(via_tuple(id), fn state -> state end )
	end 

	def current_state(id, key) do 
		Agent.get(via_tuple(id), &(Map.get(&1, key)))
	end 

	# Registry lookup 

	defp via_tuple(id) do 
		{:via, Registry, {Marketplace.Registry, id}}
	end

end
