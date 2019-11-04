defmodule Metrics do 

	def post(count, freq, size) do 
		# how many orders to create 
		# at which frequency 
		# over what size space 
		Enum.each(
			1..count, 
			fn _i-> Marketplace.Book.post(
				String.to_atom("o" <> Integer.to_string(:rand.uniform(987982), 32) |> String.downcase()), 
				:k1, 
				:rand.uniform(size)) 
			end) 
		:timer.sleep(freq * 1000)

	end

	def get_and_match() do 
		Marketplace.Book.list 
			|> Enum.map(fn {x, _} -> x end) 
			|> Enum.map(fn x -> Marketplace.Book.match(x, :k1, :rand.uniform(10)) end)
			|> Enum.count(fn x -> :ok = x end) 
	end 
end