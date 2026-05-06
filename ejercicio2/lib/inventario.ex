defmodule Inventario do
  def nuevo, do: %{}

  def agregar(inventario, %Producto{codigo: codigo} = producto) when is_map(inventario) do
    case Map.has_key?(inventario, codigo) do
      true -> {:error, :codigo_repetido}
      false -> {:ok, Map.put(inventario, codigo, producto)}
    end
  end

  def agregar(_inventario, _producto), do: {:error, :producto_invalido}

  def actualizar(inventario, codigo, nuevos_datos) when is_map(inventario) and is_map(nuevos_datos) do
    codigo = String.trim(to_string(codigo))

    case Map.get(inventario, codigo) do
      nil ->
        {:error, :producto_no_encontrado}

      producto ->
        case Producto.actualizar(producto, nuevos_datos) do
          {:ok, producto_actualizado} ->
            inventario_sin_anterior = Map.delete(inventario, codigo)

            if producto_actualizado.codigo != codigo and Map.has_key?(inventario_sin_anterior, producto_actualizado.codigo) do
              {:error, :codigo_repetido}
            else
              {:ok, Map.put(inventario_sin_anterior, producto_actualizado.codigo, producto_actualizado)}
            end

          {:error, razon} ->
            {:error, razon}
        end
    end
  end

  def eliminar(inventario, codigo) when is_map(inventario) do
    codigo = String.trim(to_string(codigo))

    case Map.has_key?(inventario, codigo) do
      true -> {:ok, Map.delete(inventario, codigo)}
      false -> {:error, :producto_no_existe}
    end
  end

  def listar(inventario) when is_map(inventario) do
    Map.values(inventario)
  end



  def productos_con_dos_vocales(inventario) do
    inventario
    |> Map.values()
    |> Enum.filter(fn producto -> contar_vocales(producto.nombre) >= 2 end)
    |> Enum.map(fn producto -> {producto.codigo, producto.nombre} end)
  end

  def productos_misma_letra(inventario) do
    inventario
    |> Map.values()
    |> Enum.filter(fn producto ->
      nombre =
        producto.nombre
        |> String.downcase()
        |> String.replace(" ", "")

      String.length(nombre) > 0 and String.first(nombre) == String.last(nombre)
    end)
  end

  def productos_precio_menor(inventario, precio_limite) when is_number(precio_limite) do
    inventario
    |> Map.values()
    |> Enum.filter(fn producto -> producto.precio < precio_limite end)
  end

  def tres_productos_mas_caros(inventario) do
    inventario
    |> Map.values()
    |> Enum.sort_by(fn producto -> producto.precio end, :desc)
    |> Enum.take(3)
  end

  def productos_entre_precios(inventario, precio_minimo, precio_maximo)
      when is_number(precio_minimo) and is_number(precio_maximo) do
    inventario
    |> Map.values()
    |> Enum.filter(fn producto ->
      producto.precio >= precio_minimo and producto.precio <= precio_maximo
    end)
    |> Enum.map(fn producto -> "#{producto.nombre} - #{producto.precio}" end)
    |> Enum.join(", ")
  end

  def agrupar_productos_por_precio(inventario) do
    grupos = %{
      "Menores a 50000" => [],
      "Entre 50000 y 100000" => [],
      "Mayores a 100000" => []
    }

    inventario
    |> Map.values()
    |> Enum.group_by(fn producto ->
      cond do
        producto.precio < 50_000 -> "Menores a 50000"
        producto.precio <= 100_000 -> "Entre 50000 y 100000"
        true -> "Mayores a 100000"
      end
    end)
    |> then(fn resultado -> Map.merge(grupos, resultado) end)
  end

  defp contar_vocales(nombre) do
    nombre
    |> String.downcase()
    |> String.graphemes()
    |> Enum.count(fn letra -> letra in ["a", "e", "i", "o", "u", "á", "é", "í", "ó", "ú"] end)
  end
end
