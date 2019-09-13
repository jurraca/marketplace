defmodule Marketplace.OrderBook do
	
	use GenServer

	@name __MODULE__

	def init(pids) do
		{:ok, pids}
	end

	def handle_call(:list, _from, pids) do
		{:reply, pids, pids}		
	end

	def handle_call(:new, _from, pids) do
		pid = create() 
		{:reply, pid, pids ++ [pid] }
	end	

	def handle_cast({:update, key, value, pid}, state) do 
		{:noreply, Marketplace.Order.post_order(key, value, pid)}
	end

	# Public API 

	def start_link() do
		GenServer.start_link(@name, [], name: @name)
	end

	def new do
		GenServer.call @name, :new
	end

	def list do 
		GenServer.call @name, :list 
	end

	def get_status(pid) do
		Marketplace.Order.current_state(pid)
	end

	def get_status(pid, key) do 
		Marketplace.Order.current_state(pid, key)
	end 

	def update(pid, key, value) do 
		GenServer.cast @name, {:update, key, value, pid}
	end

	defp create() do 
		{:ok, pid} = Marketplace.Order.start_link
		pid
	end

end

