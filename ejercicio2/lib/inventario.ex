defmodule Inventario do
  def nuevo(), do: %{}

  # -------------------------
  # CRUD
  # -------------------------

  def agregar(inventario, producto) do
    if Map.has_key?(inventario, producto.codigo) do
      {:error, "Código repetido"}
    else
      {:ok, Map.put(inventario, producto.codigo, producto)}
    end
  end

  def actualizar(inventario, codigo, nuevos_datos) do
    case Map.get(inventario, codigo) do
      nil ->
        {:error, "Producto no encontrado"}

      producto ->
        producto_actualizado = Map.merge(producto, nuevos_datos)
        {:ok, Map.put(inventario, codigo, producto_actualizado)}
    end
  end

  def eliminar(inventario, codigo) do
    if Map.has_key?(inventario, codigo) do
      {:ok, Map.delete(inventario, codigo)}
    else
      {:error, "Producto no existe"}
    end
  end

  def listar(inventario) do
    Map.values(inventario)
  end

  # -------------------------
  # CONSULTAS
  # -------------------------

  def productos_con_dos_vocales(inventario) do
    inventario
    |> Map.values()
    |> Enum.filter(fn producto ->
      contar_vocales(producto.nombre) >= 2
    end)
    |> Enum.map(fn producto ->
      {producto.codigo, producto.nombre}
    end)
  end

  defp contar_vocales(nombre) do
    nombre
    |> String.downcase()
    |> String.graphemes()
    |> Enum.count(&(&1 in ["a", "e", "i", "o", "u"]))
  end

  def productos_misma_letra(inventario) do
    inventario
    |> Map.values()
    |> Enum.filter(fn producto ->
      nombre = String.downcase(producto.nombre)
      String.first(nombre) == String.last(nombre)
    end)
  end

  def productos_precio_menor(inventario, precio_limite) do
    inventario
    |> Map.values()
    |> Enum.filter(fn producto ->
      producto.precio < precio_limite
    end)
  end

  def tres_productos_mas_caros(inventario) do
    inventario
    |> Map.values()
    |> Enum.sort_by(& &1.precio, :desc)
    |> Enum.take(3)
  end

  def productos_entre_precios(inventario, precio_minimo, precio_maximo) do
    inventario
    |> Map.values()
    |> Enum.filter(fn producto ->
      producto.precio >= precio_minimo and producto.precio <= precio_maximo
    end)
    |> Enum.map(fn producto ->
      "#{producto.nombre} - #{producto.precio}"
    end)
    |> Enum.join(", ")
  end

  def agrupar_productos_por_precio(inventario) do
    inventario
    |> Map.values()
    |> Enum.group_by(fn producto ->
      cond do
        producto.precio < 50_000 ->
          "Menores a 50000"

        producto.precio <= 100_000 ->
          "Entre 50000 y 100000"

        true ->
          "Mayores a 100000"
      end
    end)
  end
end
