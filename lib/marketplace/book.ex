defmodule Marketplace.Book do
	@moduledoc """
	GenServer exposing public endpoints for interacting with the marketplace "orderbook".
	"""

	use GenServer
	@name Marketplace.Server

	# Public API
	def init(init_arg) do
		{:ok, init_arg}
	end

	def start_link(_) do
		GenServer.start_link(@name, [], name: @name)
	end

	def list do
		GenServer.call @name, :list
	end

	def post(name, key, value) do
		GenServer.call @name, {:post, key, value, name}
	end

	def match(name, key, value) do
		GenServer.call @name, {:match, key, value, name}
	end

	def get(name) do
		GenServer.call @name, {:get, name}
	end

	def get(name, key) do
		GenServer.call @name, {:get, name, key}
	end

end
