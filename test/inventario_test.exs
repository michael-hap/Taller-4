defmodule InventarioTest do
  use ExUnit.Case

  test "no permite agregar productos con código repetido" do
    {:ok, producto} = Producto.crear("A1", "Arroz", 5000, 10)
    {:ok, inventario} = Inventario.agregar(%{}, producto)

    assert Inventario.agregar(inventario, producto) == {:error, :codigo_repetido}
  end

  test "retorna productos con al menos dos vocales como tuplas" do
    {:ok, arroz} = Producto.crear("A1", "Arroz", 5000, 10)
    {:ok, pan} = Producto.crear("P1", "Pan", 2000, 5)

    {:ok, inventario} = Inventario.agregar(%{}, arroz)
    {:ok, inventario} = Inventario.agregar(inventario, pan)

    assert Inventario.productos_con_dos_vocales(inventario) == [{"A1", "Arroz"}]
  end

  test "agrupa productos por rango de precio" do
    {:ok, bajo} = Producto.crear("B1", "Panela", 40000, 3)
    {:ok, medio} = Producto.crear("M1", "Azucar", 70000, 2)
    {:ok, alto} = Producto.crear("A1", "Lavadora", 120000, 1)

    {:ok, inventario} = Inventario.agregar(%{}, bajo)
    {:ok, inventario} = Inventario.agregar(inventario, medio)
    {:ok, inventario} = Inventario.agregar(inventario, alto)

    grupos = Inventario.agrupar_productos_por_precio(inventario)

    assert length(grupos["Menores a 50000"]) == 1
    assert length(grupos["Entre 50000 y 100000"]) == 1
    assert length(grupos["Mayores a 100000"]) == 1
  end
end
