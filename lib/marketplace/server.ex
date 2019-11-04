defmodule Marketplace.Server do 
	use GenServer 

	alias Marketplace.{Order, OrderSupervisor}

	def init(_) do
		{:ok, Marketplace.Stash.get()}
	end

	def handle_call(:list, _from, _state) do 
		list = Registry.select( Marketplace.Registry, 
		[{
			{:"$1", :_, :_}, 
			[], 
			[:"$1"]
			}])

		{ :reply,
		Enum.map(list, fn x -> {x, Order.current_state(x)} end),
		nil
		}
	end 

	def handle_call({:get, id}, _from, _state) do
		case lk(id) do 
			:ok -> {:reply, {id, Order.current_state(id)}, nil}
			{:error, msg} -> {:reply, msg, nil}
		end 
	end

	def handle_call({:get, id, key}, _from, _state) do
		case lk(id) do 
			:ok -> {:reply, {id, {key, Order.current_state(id, key)}}, nil}
			{:error, msg} -> {:reply, msg, nil} 
		end 
	end	

	def handle_call({:post, key, value, id}, _from, _state) do 

		resp = case lk(id) do 	
			:ok -> Order.post_order(key, value, id)	
			{:error, msg} -> {OrderSupervisor.start_child({id, key, value}), msg <> " Creating one."}
			end
			{
				:reply, 
				resp ,
				nil				
			}		 
	end

	def handle_call({:match, key, value, id}, _from, _state) do 

		case lk(id) do 
			:ok -> {:reply, Order.post_match(key, value, id), nil}
			{:error, msg} -> {:reply, msg, nil}
		end
	end

	defp lk(id), do: Registry.lookup(Marketplace.Registry, id) |> lookup(id)

	#defp lk(id, key), do: Registry.lookup(Marketplace.Registry, id) |> lookup(id, key)
	
	defp lookup([{_pid, _} | _tail], _id), do: :ok

	defp lookup([], _id), do: {:error, "No order by that name."}
	
	def terminate(_reason, ids) do 
		Marketplace.Stash.update(ids)
	end

end 
