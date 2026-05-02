defmodule GimnasioApp.Gimnasio do
  alias GimnasioApp.Socio

  def main do
    %{}
  end

  def crear_socio(socios, cedula, nombre, edad) do
    if Map.has_key?(socios, cedula) do
      {:error, :cedula_duplicada}
    else
      case Socio.nuevo(cedula, nombre, edad) do
        {:ok, socio} ->
          socios_actualizados = Map.put(socios, cedula, socio)
          {:ok, socios_actualizados}

        {:error, razon} ->
          {:error, razon}
      end
    end
  end

  def buscar_socio(socios, cedula) do
    case Map.get(socios, cedula) do
      nil -> {:error, :no_encontrado}
      socio -> {:ok, socio}
    end
  end

  def eliminar_socio(socios, cedula) do
    if Map.has_key?(socios, cedula) do
      socios_actualizados = Map.delete(socios, cedula)
      {:ok, socios_actualizados}
    else
      {:error, :no_encontrado}
    end
  end

  def listar_socios(socios) do
    {:ok, Map.values(socios)}
  end
end
