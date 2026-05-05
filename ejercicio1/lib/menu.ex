defmodule GimnasioApp.Menu do
  alias GimnasioApp.Gimnasio

  def iniciar do
    socios = Gimnasio.main()
    loop(socios)
  end

  defp loop(socios) do
    IO.puts("""

    ===== MENÚ GIMNASIO =====
    1. Crear socio
    2. Eliminar socio
    3. Inscribir socio en clase
    4. Desinscribir socio de clase
    5. Buscar socio por cédula
    6. Listar todos los socios
    7. Listar socios por clase
    8. Listar clases de un socio
    9. Salir
    """)
    opcion =
      "Seleccione una opción: "
      |> IO.gets()
      |> String.trim()

    case opcion do
      "1" ->
        crear_socio(socios)

      "2" ->
        eliminar_socio(socios)

      "3" ->
        inscribir_clase(socios)

      "4" ->
        desinscribir_clase(socios)

      "5" ->
        buscar_socio(socios)

      "6" ->
        listar_socios(socios)

      "7" ->
        listar_socios_por_clase(socios)

      "8" ->
        listar_clases_socio(socios)

      "9" ->
        IO.puts("Saliendo del sistema...")

      _ ->
        IO.puts("Opción inválida")
        loop(socios)
    end
  end

  defp crear_socio(socios) do
    cedula = leer_texto("Cédula: ")
    nombre = leer_texto("Nombre: ")
    edad = leer_entero("Edad: ")

    case Gimnasio.crear_socio(socios, cedula, nombre, edad) do
      {:ok, socios_actualizados} ->
        IO.puts("Socio creado correctamente.")
        loop(socios_actualizados)

      {:error, motivo} ->
        IO.puts("Error: #{motivo}")
        loop(socios)
    end
  end

  defp eliminar_socio(socios) do
    cedula = leer_texto("Cédula del socio a eliminar: ")

    case Gimnasio.eliminar_socio(socios, cedula) do
      {:ok, socios_actualizados} ->
        IO.puts("Socio eliminado correctamente.")
        loop(socios_actualizados)

      {:error, motivo} ->
        IO.puts("Error: #{motivo}")
        loop(socios)
    end
  end

  defp buscar_socio(socios) do
    cedula = leer_texto("Cédula del socio: ")

    case Gimnasio.buscar_socio(socios, cedula) do
      {:ok, socio} ->
        IO.inspect(socio, label: "Socio encontrado")
        loop(socios)

      {:error, motivo} ->
        IO.puts("Error: #{motivo}")
        loop(socios)
    end
  end

  defp listar_socios(socios) do
    case Gimnasio.listar_socios(socios) do
      {:ok, lista} ->
        IO.inspect(lista, label: "Socios")
        loop(socios)
    end
  end

  defp leer_texto(mensaje) do
    mensaje
    |> IO.gets()
    |> String.trim()
  end

  defp leer_entero(mensaje) do
    mensaje
    |> IO.gets()
    |> String.trim()
    |> String.to_integer()
  end
  defp inscribir_clase(socios) do
    cedula = leer_texto("Cédula del socio: ")
    clase = leer_texto("Clase a inscribir: ")

    case Gimnasio.inscribir_clase(socios, cedula, clase) do
      {:ok, socios_actualizados} ->
        IO.puts("Clase inscrita correctamente.")
        loop(socios_actualizados)

      {:error, motivo} ->
        IO.puts("Error: #{motivo}")
        loop(socios)
    end
  end

  defp desinscribir_clase(socios) do
    cedula = leer_texto("Cédula del socio: ")
    clase = leer_texto("Clase a desinscribir: ")

    case Gimnasio.desinscribir_clase(socios, cedula, clase) do
      {:ok, socios_actualizados} ->
        IO.puts("Clase desinscrita correctamente.")
        loop(socios_actualizados)

      {:error, motivo} ->
        IO.puts("Error: #{motivo}")
        loop(socios)
    end
  end

  defp listar_socios_por_clase(socios) do
    clase = leer_texto("Clase: ")

    case Gimnasio.listar_socios_por_clase(socios, clase) do
      {:ok, lista} ->
        IO.inspect(lista, label: "Socios inscritos en #{clase}")
        loop(socios)
    end
  end

  defp listar_clases_socio(socios) do
    cedula = leer_texto("Cédula del socio: ")

    case Gimnasio.listar_clases_socio(socios, cedula) do
      {:ok, clases} ->
        IO.inspect(clases, label: "Clases del socio")
        loop(socios)

      {:error, motivo} ->
        IO.puts("Error: #{motivo}")
        loop(socios)
    end
  end
end
