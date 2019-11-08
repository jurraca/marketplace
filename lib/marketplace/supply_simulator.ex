defmodule Marketplace.SupplySimulator do 
	use Task

	def start_link(_) do 
		Task.start_link(__MODULE__, :run, [])
	end 

	def get_and_match() do 
		Marketplace.Book.list 
			|> Enum.take(:rand.uniform(4))
			|> Enum.map(fn {x, y} -> {x, Map.get(y, :k1) } end) 
			|> Enum.map(fn {x, y} -> Marketplace.Book.match(x, :k1, y) end)	
			|> Enum.count(fn x -> {:ok, "Order archived."} end)	
	end

	def sleep(seconds) do 
		receive do 
			after seconds*100 -> nil 
		end 
	end 

	def run do 

		get_and_match()

		sleep(:rand.uniform(4))

		run() 
	end  

end 