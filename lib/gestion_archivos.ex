defmodule GimnasioApp.GestionArchivos do
  alias GimnasioApp.Socio
  @archivo "socios.csv"

  def guardar_socios(socios) do
    contenido =
      socios
      |> Enum.map(fn {_cedula, socio} ->
        clases = Enum.join(socio.clases, ";")
        "#{socio.cedula}, #{socio.nombre}, #{socio.edad}, #{clases}"
      end)
      |> Enum.join("\n")

    File.write(@archivo, "cedula,nombre,edad,clase\n" <> contenido)
  end

  def cargar_socios do
    case File.read(@archivo) do
      {:ok, contenido} ->
        contenido
        |> String.split("\n", trim: true)
        |>tl()
        |>Enum.reduce(%{}, fn linea, acc ->
          [cedula, nombre, edad_texto, clases_texto] =
            String.split(linea, ",", parts: 4)

            cedula= String.trim(cedula)
            nombre= String.trim(nombre)
            edad = edad_texto |> String.trim() |> String.to_integer()

            clases=
              clases_texto
              |> String.trim()
              |> String.split(";", trim: true)
              |> Enum.map(&String.trim/1)
            socio = %Socio{
              cedula: cedula,
              nombre: nombre,
              edad: edad,
              clases: clases
            }

            Map.put(acc, cedula, socio)
        end)
      {:error, :enoent} ->
        %{}

      {:error, _razon} ->
        %{}
    end
  end
end
