defmodule Marketplace.Stash do 
	use GenServer


	@me __MODULE__ 

	def start_link(_) do
		GenServer.start_link(__MODULE__, [], name: @me)
	end

	def get do 
		GenServer.call(@me, { :get })
	end 

	def update(pids) do 
		GenServer.cast(@me, {:update, pids})
	end

	def init(initial) do 
		{:ok, initial}
	end 

	def handle_call( { :get }, _from, pid_list ) do 
		{:reply, pid_list, pid_list}
	end 

	def handle_cast( {:update, pids}, _pid_list) do 
		{:noreply, pids} 
	end

end

