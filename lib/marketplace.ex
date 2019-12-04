defmodule Marketplace do
  @moduledoc """
  Marketplace is an OTP application that provides the skeleton of a marketplace or trading engine. The impetus for building it was that simulating marketplace behavior is quite difficult, but thanks to BEAM process isolation, we can scale simulations while keeping individual Agents operating independently, that is, much closer to the reality of markets: independent actors, working in parallel at high volume.  

  The feature set is limited, since every marketplace is different. (The main todo is a pubsub to guarantee data ordering). 

  ### Usage 

  `iex -S mix` will launch the application without simulators. You can use the defaults, or define your own simulators, and start them with `Supervisor.start_child()/2`. 
   

  ### Logging 
  
  By default, the application issues log messages to syslog using `ex_syslogger`. Feel free to silence this as the volume of log messages can grow rapidly.  
  """

end
