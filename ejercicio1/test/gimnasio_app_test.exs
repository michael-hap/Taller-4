defmodule GimnasioAppTest do
  use ExUnit.Case
  doctest GimnasioApp

  test "greets the world" do
    assert GimnasioApp.hello() == :world
  end
end
