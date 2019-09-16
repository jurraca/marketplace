defmodule Marketplace.OrderBook do

	use GenServer 

	@name Marketplace.Server

	# Public API 
	def init(init_arg) do 
		{:ok, init_arg}
	end 
	
	def start_link(_) do
		GenServer.start_link(@name, [], name: @name)
	end

	def new(name) do
		GenServer.call @name, {:new, name} 
	end

	def list do 
		GenServer.call @name, :list 	
	end

	def post(pid, key, value) do 
		GenServer.call @name, {:post, key, value, pid}
	end

	def match(pid, key, value) do 
		GenServer.call @name, {:match, key, value, pid}
	end 

	def get(pid) do
		GenServer.call @name, {:get, pid}
	end

	def get(pid, key) do 
		GenServer.call @name, {:get, pid, key}
	end 

end
