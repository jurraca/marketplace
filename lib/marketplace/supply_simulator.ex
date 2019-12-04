defmodule Marketplace.SupplySimulator do 
	use Task

	def start_link(_) do 
		Task.start_link(__MODULE__, :run, [])
	end 

	def get_and_match() do 
		Marketplace.Book.list 
			|> Enum.take(:rand.uniform(4))
			|> Enum.map(fn {name, state} -> {name, Map.get(state, :k1) } end) 
			|> Enum.map(fn {name, value} -> Marketplace.Book.match(name, :k1, value) end)	
			|> Enum.count(fn _x -> {:ok, "Order archived."} end)	
	end

	def sleep(seconds) do 
		receive do 
			after seconds*100 -> nil 
		end 
	end 

	def run do 

		case Marketplace.Book.list |> Enum.count > 100 do 
			true -> get_and_match()
			false -> sleep(1_000)
		end 

		sleep(:rand.uniform(4))

		run() 
	end  

end 