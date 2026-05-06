defmodule Producto do
  @derive Jason.Encoder
  defstruct codigo: "", nombre: "", precio: 0, cantidad: 0

  def crear(codigo, nombre, precio, cantidad) do
    cond do
      codigo == "" or is_nil(codigo) ->
        {:error, :codigo_obligatorio}

      nombre == "" or is_nil(nombre) ->
        {:error, :nombre_obligatorio}

      String.length(codigo) > 5 ->
        {:error, :codigo_muy_largo}

      not nombre_valido?(nombre) ->
        {:error, :nombre_invalido}

      not is_number(precio) or precio < 0 ->
        {:error, :precio_invalido}

      not is_integer(cantidad) or cantidad < 0 ->
        {:error, :cantidad_invalida}

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

  defp nombre_valido?(nombre) do
    Regex.match?(~r/^[A-Za-zÁÉÍÓÚáéíóúÑñ\s]+$/, nombre)
  end
end
