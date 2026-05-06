defmodule Producto do
  @derive Jason.Encoder
  @enforce_keys [:codigo, :nombre, :precio, :cantidad]
  defstruct [:codigo, :nombre, :precio, :cantidad]

  def crear(codigo, nombre, precio, cantidad) do
    codigo = limpiar_texto(codigo)
    nombre = limpiar_texto(nombre)

    cond do
      codigo == "" or String.length(codigo) > 5 ->
        {:error, :codigo_invalido}

      nombre == "" or not Regex.match?(~r/^\p{L}+(\s\p{L}+)*$/u, nombre) ->
        {:error, :nombre_invalido}

      not is_number(precio) or precio < 0 ->
        {:error, :precio_invalido}

      not is_integer(cantidad) or cantidad < 0 ->
        {:error, :cantidad_invalida}

      true ->
        {:ok, %__MODULE__{codigo: codigo, nombre: nombre, precio: precio, cantidad: cantidad}}
    end
  end

  def actualizar(%__MODULE__{} = producto, nuevos_datos) when is_map(nuevos_datos) do
    codigo = Map.get(nuevos_datos, :codigo, producto.codigo)
    nombre = Map.get(nuevos_datos, :nombre, producto.nombre)
    precio = Map.get(nuevos_datos, :precio, producto.precio)
    cantidad = Map.get(nuevos_datos, :cantidad, producto.cantidad)

    crear(codigo, nombre, precio, cantidad)
  end

  defp limpiar_texto(valor) when is_binary(valor), do: String.trim(valor)
  defp limpiar_texto(_valor), do: ""
end
