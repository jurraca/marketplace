defmodule Marketplace.SupplySimulator do 
	use Task

	def start_link(_) do 
		Task.start_link(__MODULE__, :run, [])
	end 

	def get_and_match() do 
		Marketplace.Book.list 
			|> Enum.take(2)
			|> Enum.map(fn {x, _} -> x end)
			|> Enum.map(fn x -> Marketplace.Book.match(x, :k1, :rand.uniform(30)) end)
	end

	def sleep(seconds) do 
		receive do 
			after seconds*1000 -> nil 
		end 
	end 

	def run do 

		get_and_match()

		sleep(:rand.uniform(2))

		run() 
	end  

end 