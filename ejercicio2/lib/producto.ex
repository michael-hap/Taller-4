defmodule Producto do
  defstruct codigo: "", nombre: "", precio: 0, cantidad: 0

  def crear(codigo, nombre, precio, cantidad) do
    cond do
      codigo == "" or String.length(codigo) > 5 ->
        {:error, "Código inválido (máx 5 caracteres)"}

      not Regex.match?(~r/^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$/, nombre) ->
        {:error, "Nombre solo letras"}

      not is_number(precio) or precio < 0 ->
        {:error, "Precio inválido"}

      not is_integer(cantidad) or cantidad < 0 ->
        {:error, "Cantidad inválida"}

      true ->
        {:ok,
         %Producto{
           codigo: codigo,
           nombre: nombre,
           precio: precio,
           cantidad: cantidad
         }}
    end
  end
end
