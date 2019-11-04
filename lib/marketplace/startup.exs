defmodule Startup do 

	def main do 
		{:ok, sup} = Marketplace.Supervisor.start_link([])
		children = Supervisor.which_children(sup)	

		IO.puts({sup, children})	
	end 

end 