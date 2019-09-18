defmodule Simpost do 

	def post(name, key, val) do 
		Marketplace.OrderBook.new(name)
		Marketplace.OrderBook.post(name, key, val)
	end 

	def create_order() do 

		nameset = [:o0, :o1, :o2, :o3, :o4]
		keyset = [:k0, :k1, :k2, :k3, :k4]
		
		name = Enum.at(nameset, :rand.uniform(4))
		val = :rand.uniform(10) 
		key = Enum.at(keyset, :rand.uniform(4))
		
		post(name, key, val)
		
		Process.sleep(:rand.uniform(5000))

	end 

end