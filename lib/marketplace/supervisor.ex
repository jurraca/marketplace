defmodule Marketplace.Supervisor do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Supervisor

  def start_link(init_arg) do

    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)

  end 

  def init(_init_arg) do
    children = [

       {Marketplace.Stash, []},
       {Marketplace.OrderSupervisor, nil},
       {Registry, [keys: :unique, name: Marketplace.Registry]}, 
       {Marketplace.OrderBook, nil},

    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options

    opts = [strategy: :rest_for_one, name: Marketplace.Supervisor]

    Supervisor.init(children, opts)
  end

end
