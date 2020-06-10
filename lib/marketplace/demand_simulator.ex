defmodule Marketplace.DemandSimulator do
  @moduledoc """
  	Long-running Task to simulate demand (i.e. post orders to the marketplace).
  """
  use Task

  def start_link(arg) do
    Task.start_link(__MODULE__, :run, [arg])
  end

  @doc """
  	Post an order of a given size every 100 ms.
  	Order names are generated using a random number encoded to base 32.
  """
  def post(order_size) do
    ("o" <> Integer.to_string(:rand.uniform(987_982), 32))
    |> String.to_atom()
    |> String.downcase()
    |> Marketplace.Book.post(:k1, order_size)

    sleep(:rand.uniform(1))
  end

  def sleep(seconds) do
    receive do
    after
      seconds * 100 -> nil
    end
  end

  @doc """
  If the orderbook contains more than 30,000 orders, sleep for a while and let the `SupplySimulator` catch up.
  Else, post order with the given size `arg`.
  """

  def run(arg) do
    case Marketplace.Book.list() |> Enum.count() > 30_000 do
      true -> sleep(100)
      false -> post(:rand.uniform(arg))
    end

    run(arg)
  end
end
