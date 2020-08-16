defmodule Marketplace.Server do
  @moduledoc """
  	GenServer Callback module. This GenServer does not maintain state, only dispatches calls.
  """
  use GenServer
  require Logger

  alias Marketplace.{Order, OrderSupervisor}

  @doc false
  def init(_) do
    {:ok, nil}
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, [])
  end

  @doc """
  Lists all orders in the marketplace, returns a list of `{order_name, state}`
  """
  def handle_call(:list, _from, _state) do
    list =
      Marketplace.Registry
      |> Registry.select(
        [
          {
            {:"$1", :_, :_},
            [],
            [:"$1"]
          }
        ]
      )
    |> Enum.map(fn x -> {x, Order.current_state(x)} end)

    {:reply, list, nil}
  end

  def handle_call({:get, id}, _from, _state) do
    case lk(id) do
      :ok -> {:reply, {id, Order.current_state(id)}, nil}
      nil -> {:reply, "no order exists", nil}
    end
  end

  def handle_call({:get, id, key}, _from, _state) do
    case lk(id) do
      :ok -> {:reply, {id, {key, Order.current_state(id, key)}}, nil}
      nil -> {:reply, nil, nil}
    end
  end

  def handle_call({:post, key, value, id}, _from, _state) do
    resp =
      case lk(id) do
        :ok ->
          Order.post_order(key, value, id)

        nil ->
          {OrderSupervisor.start_child({id, key, value}), "No order exists. Creating one."}
      end

    {:reply, resp, nil}
  end

  @doc """
  Attempt to match an order. Check whether it exists, whether the match is valid, and whether it succeeds.
  """
  def handle_call({:match, key, value, id} = opts, _from, _state) do
    case lk(id) do
      :ok -> valid_match?({id, key, value})
      nil -> nil
    end
    |> handle_match(opts)
  end

  # Helpers

  defp lk(id), do: Registry.lookup(Marketplace.Registry, id) |> exists?(id)

  defp exists?([{_pid, _} | _tail], _id), do: :ok

  defp exists?([], _id), do: nil

  @doc """
  Terminate and stop `Order` agent, log archive message.
  """
  def archive(id) do
    Order.terminate(id) # unregister the order from Registry
    :ok = Agent.stop(Order.via_tuple(id), :normal) # Stop the agent.
    Logger.info("Order archived.")
    {:ok, "Order archived"}
  end

  def valid_match?({id, key, value}) do
    Order.current_state(id, key) - value > 0
  end

  def handle_match(true, {key, value, id}), do: Order.post_match(key, value, id)

  def handle_match(false, _opts), do: {:reply, "Invalid match, order has been filled.", nil}

  def handle_match(nil, _), do: {:reply, "no order exists by that name", nil}
end
