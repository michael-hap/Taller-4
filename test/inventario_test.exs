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

    assert resultado == {:error, :codigo_repetido}
  end

  test "retorna productos con al menos dos vocales como tuplas" do
    inventario = Inventario.nuevo()

    {:ok, arroz} = Producto.crear("A1", "Arroz", 5000, 10)
    {:ok, pan} = Producto.crear("P1", "Pan", 2000, 5)

    {:ok, inventario} = Inventario.agregar(inventario, arroz)
    {:ok, inventario} = Inventario.agregar(inventario, pan)

    assert Inventario.productos_con_dos_vocales(inventario) == [{"A1", "Arroz"}]
  end

  test "agrupa productos por rango de precio" do
    inventario = Inventario.nuevo()

    {:ok, bajo} = Producto.crear("B1", "Panela", 40000, 3)
    {:ok, medio} = Producto.crear("M1", "Azucar", 70000, 2)
    {:ok, alto} = Producto.crear("A1", "Lavadora", 120000, 1)

    {:ok, inventario} = Inventario.agregar(inventario, bajo)
    {:ok, inventario} = Inventario.agregar(inventario, medio)
    {:ok, inventario} = Inventario.agregar(inventario, alto)

    grupos = Inventario.agrupar_productos_por_precio(inventario)

    assert length(grupos["Menores a 50000"]) == 1
    assert length(grupos["Entre 50000 y 100000"]) == 1
    assert length(grupos["Mayores a 100000"]) == 1
  end
end
