defmodule Marketplace.Server do 
	use GenServer 
	require Logger

	alias Marketplace.{Order, OrderSupervisor}

	@moduledoc """
		GenServer Callback module. This GenServer does not maintain state, only dispatches calls.
	"""
	@doc false 
	def init(_) do
		{:ok, nil}
	end

	def start_link(_) do
		GenServer.start_link(__MODULE__, [])
	end 

	@doc """ 
	Lists all orders in the marketplace, returns a list of `{order_name, state}`
	"""

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
			{:error, "No order by that name."} -> {OrderSupervisor.start_child({id, key, value}), "No order exists. Creating one."}
			{:error, "Order archived."} -> {"Order was filled and archived."}
			end
			{
				:reply, 
				resp ,
				nil				
			}		 
	end

	def handle_call({:match, key, value, id}, _from, _state) do 

		resp = case lk(id) do 
			:ok -> valid_match?({id, key, value})
			{:error, msg} -> msg
		 	end

		case resp do 
			true -> {:reply, Order.post_match(key, value, id), nil}
			false -> {:reply, archive(id), nil}
			msg -> {:reply, msg, nil}
		end
	end

	defp lk(id), do: Registry.lookup(Marketplace.Registry, id) |> exists?(id)

	#defp lk(id, key), do: Registry.lookup(Marketplace.Registry, id) |> lookup(id, key)
	
	defp exists?([{pid, _} | _tail], id), do: :ok

	defp exists?([], _id), do: {:error, "No order by that name."}

	@doc """
	Terminate and stop `Order` agent, log archive message.
	"""
	def archive(id) do 
		Order.terminate(id)
		:ok = Agent.stop(Order.via_tuple(id), :normal)
		return = "Order archived."
		Logger.info(return)
		{:ok, return}
	end 

	def valid_match?({id, key, value}) do 
		Order.current_state(id, key) - value > 0
	end 

end 
