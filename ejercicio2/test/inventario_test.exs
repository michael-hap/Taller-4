defmodule InventarioTest do
  use ExUnit.Case

  alias Producto
  alias Inventario

  test "agregar producto correctamente" do
    inventario = Inventario.nuevo()

    {:ok, producto} = Producto.crear("A1", "Arroz", 50000, 10)

    {:ok, inventario_actualizado} =
      Inventario.agregar(inventario, producto)

    assert Map.has_key?(inventario_actualizado, "A1")
    assert inventario_actualizado["A1"].nombre == "Arroz"
  end

  test "no permite agregar producto con codigo repetido" do
    inventario = Inventario.nuevo()

    {:ok, producto1} = Producto.crear("A1", "Arroz", 50000, 10)
    {:ok, inventario} = Inventario.agregar(inventario, producto1)

    {:ok, producto2} = Producto.crear("A1", "Leche", 30000, 5)

    resultado = Inventario.agregar(inventario, producto2)

    assert resultado == {:error, "Código repetido"}
  end
end
