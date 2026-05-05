defmodule ArchivoJSON do
  @ruta_archivo "data/productos.json"

  def guardar(inventario) do
    lista_productos = Map.values(inventario)

    case Jason.encode(lista_productos) do
      {:ok, json} ->
        File.write(@ruta_archivo, json)

      {:error, error} ->
        IO.puts("Error al guardar: #{inspect(error)}")
    end
  end

  def cargar() do
    case File.read(@ruta_archivo) do
      {:ok, contenido} ->
        case Jason.decode(contenido, keys: :atoms) do
          {:ok, lista} ->
            lista
            |> Enum.map(fn producto_mapa ->
              {producto_mapa.codigo, struct(Producto, producto_mapa)}
            end)
            |> Enum.into(%{})

          {:error, _} ->
            %{}
        end

      {:error, _} ->
        %{}
    end
  end
end
