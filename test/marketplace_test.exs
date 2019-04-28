defmodule MarketplaceTest do
  use ExUnit.Case
  doctest Marketplace

  test "greets the world" do
    assert Marketplace.hello() == :world
  end
end
