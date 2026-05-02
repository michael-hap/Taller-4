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

  def inscribir_clase(socios, cedula, clase) do
    case Map.get(socios, cedula) do
      nil ->
        {:error, :no_encontrado}

      socio ->
        case Socio.inscribir_clase(socio, clase) do
          {:ok, socio_actualizado} ->
            socios_actualizados = Map.put(socios, cedula, socio_actualizado)
            {:ok, socios_actualizados}

          {:error, razon} ->
            {:error, razon}
        end
    end
  end

  def desinscribir_clase(socios, cedula, clase) do
    case Map.get(socios, cedula) do
      nil ->
        {:error, :no_encontrado}

      socio ->
        case Socio.desinscribir_clase(socio, clase) do
          {:ok, socio_actualizado} ->
            socios_actualizados = Map.put(socios, cedula, socio_actualizado)
            {:ok, socios_actualizados}
        end
    end
  end

  def listar_clases_socio(socios, cedula) do
    case Map.get(socios, cedula) do
      nil ->
        {:error, :no_encontrado}

      socio ->
        Socio.listar_clases(socio)
    end
  end

  def listar_socios_por_clase(socios, clase) do
    socios_filtrados =
      socios
      |>Map.values()
      |>Enum.filter(fn socio -> Enum.member?(socio.clases, clase)end)

      {:ok, socios_filtrados}
  end
end
