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
    3. Buscar socio por cédula
    4. Listar socios
    5. Salir
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
        buscar_socio(socios)

      "4" ->
        listar_socios(socios)

      "5" ->
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
end
