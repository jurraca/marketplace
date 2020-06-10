defmodule Marketplace.OrderSupervisor do
  use DynamicSupervisor
  require Logger

  @me OrderSupervisor

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, :no_args, name: @me)
  end

  def init(:no_args) do
    DynamicSupervisor.init(strategy: :one_for_one, restart: :temporary)
  end

  def start_child({id, key, val}) do
    DynamicSupervisor.start_child(@me, {Marketplace.Order, {id, key, val}})
    Logger.info("Created new order.")
  end
end
