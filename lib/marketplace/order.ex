defmodule Marketplace.Order do
  @moduledoc """
  Each order is a standalone agent under an `OrderSupervisor`.
  Handles get, post, update as well as Registry actions.
  """

  use Agent, restart: :temporary
  require Logger

  def start_link({name, key, val}) do
    Agent.start_link(fn -> %{key => val} end, name: via_tuple(name))
  end

  def post_order(key, val, name) when is_integer(val) do
    Agent.update(
      via_tuple(name),
      fn map -> Map.update(map, key, val, &(&1 + val)) end
    )

    Logger.info("Order posted.")
  end

  def post_match(key, val, name) when is_integer(val) do
    Agent.update(
      via_tuple(name),
      fn map -> Map.update(map, key, 0, &(&1 - val)) end
    )

    Logger.info("Match succeeded.")
  end

  def current_state(name) do
    Agent.get(via_tuple(name), fn state -> state end)
  end

  def current_state(name, key) do
    Agent.get(via_tuple(name), &Map.get(&1, key))
  end

  def terminate(name) do
    :ok = Registry.unregister(Marketplace.Registry, name)
  end

  def via_tuple(name) do
    {:via, Registry, {Marketplace.Registry, name}}
  end
end
