defmodule ArchivoJSON do
  @ruta_archivo "data/json/productos.json"

  def guardar(inventario) when is_map(inventario) do
    File.mkdir_p(Path.dirname(@ruta_archivo))

    inventario
    |> Map.values()
    |> Jason.encode(pretty: true)
    |> case do
      {:ok, json} ->
        case File.write(@ruta_archivo, json) do
          :ok -> {:ok, :guardado}
          {:error, razon} -> {:error, {:error_escritura, razon}}
        end

      {:error, razon} ->
        {:error, {:error_codificacion, razon}}
    end
  end

  def cargar do
    case File.read(@ruta_archivo) do
      {:ok, ""} ->
        {:ok, %{}}

      {:ok, contenido} ->
        decodificar(contenido)

      {:error, :enoent} ->
        {:ok, %{}}

      {:error, razon} ->
        {:error, {:error_lectura, razon}}
    end
  end

  defp decodificar(contenido) do
    case Jason.decode(contenido, keys: :atoms) do
      {:ok, lista} when is_list(lista) ->
        lista
        |> Enum.reduce_while({:ok, %{}}, fn mapa, {:ok, inventario} ->
          case Producto.crear(mapa.codigo, mapa.nombre, mapa.precio, mapa.cantidad) do
            {:ok, producto} ->
              {:cont, {:ok, Map.put(inventario, producto.codigo, producto)}}

            {:error, razon} ->
              {:halt, {:error, {:producto_invalido_en_archivo, razon}}}
          end
        end)

      {:ok, _otro_formato} ->
        {:error, :formato_json_invalido}

      {:error, razon} ->
        {:error, {:error_json, razon}}
    end
  end
end
