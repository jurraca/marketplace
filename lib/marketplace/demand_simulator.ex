defmodule Marketplace.DemandSimulator do 
	use Task

	def start_link(arg) do
		Task.start_link(__MODULE__, :run, [ arg ])
	end

	def post(order_size) do 
		Marketplace.Book.post(
			String.to_atom("o" <> Integer.to_string(:rand.uniform(987982), 32) |> String.downcase()), 
			:k1, 
			order_size)  
	end

	def sleep(seconds) do 
		receive do 
			after seconds*1000 -> nil 
		end 
	end 

	def run(arg) do 

		post(:rand.uniform(arg))
		sleep(:rand.uniform(1))

		run(arg) 
	end  

end