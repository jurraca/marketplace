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
		sleep(:rand.uniform(1))
	end

	def sleep(seconds) do 
		receive do 
			after seconds*100 -> nil 
		end 
	end 

	def run(arg) do 

		case Marketplace.Book.list |> Enum.count > 30_000 do 
			true -> sleep(100)
			false -> post(:rand.uniform(arg))
		end 

		run(arg) 
	end  

end