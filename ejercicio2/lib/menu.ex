defmodule Menu do
  def iniciar() do
    inventario = ArchivoJSON.cargar()
    ejecutar_menu(inventario)
  end

  defp ejecutar_menu(inventario) do
    IO.puts("""
    1. Agregar producto
    2. Listar productos
    3. Actualizar producto
    4. Eliminar producto
    5. Consultas
    0. Salir
    """)

    opcion = IO.gets("Seleccione una opción: ") |> String.trim()

    case opcion do
      "1" ->
        nuevo_inventario = agregar_producto(inventario)
        ejecutar_menu(nuevo_inventario)

      "2" ->
        listar_productos(inventario)
        ejecutar_menu(inventario)

      "3" ->
        nuevo_inventario = actualizar_producto(inventario)
        ejecutar_menu(nuevo_inventario)

      "4" ->
        nuevo_inventario = eliminar_producto(inventario)
        ejecutar_menu(nuevo_inventario)

      "5" ->
        ejecutar_consultas(inventario)
        ejecutar_menu(inventario)

      "0" ->
        IO.puts("Saliendo...")

      _ ->
        IO.puts("Opción inválida")
        ejecutar_menu(inventario)
    end
  end

  defp agregar_producto(inventario) do
    codigo = IO.gets("Código: ") |> String.trim()
    nombre = IO.gets("Nombre: ") |> String.trim()
    precio = IO.gets("Precio: ") |> String.trim() |> String.to_integer()
    cantidad = IO.gets("Cantidad: ") |> String.trim() |> String.to_integer()

    case Producto.crear(codigo, nombre, precio, cantidad) do
      {:ok, producto} ->
        case Inventario.agregar(inventario, producto) do
          {:ok, inventario_actualizado} ->
            ArchivoJSON.guardar(inventario_actualizado)
            IO.puts("Producto agregado")
            inventario_actualizado

          {:error, mensaje} ->
            IO.puts(mensaje)
            inventario
        end

      {:error, mensaje} ->
        IO.puts(mensaje)
        inventario
    end
  end

  defp listar_productos(inventario) do
    Inventario.listar(inventario)
    |> Enum.each(fn producto ->
      IO.puts("#{producto.codigo} - #{producto.nombre} - #{producto.precio} - #{producto.cantidad}")
    end)
  end

  defp actualizar_producto(inventario) do
    codigo = IO.gets("Código del producto: ") |> String.trim()
    nuevo_precio = IO.gets("Nuevo precio: ") |> String.trim() |> String.to_integer()

    case Inventario.actualizar(inventario, codigo, %{precio: nuevo_precio}) do
      {:ok, inventario_actualizado} ->
        ArchivoJSON.guardar(inventario_actualizado)
        IO.puts("Producto actualizado")
        inventario_actualizado

      {:error, mensaje} ->
        IO.puts(mensaje)
        inventario
    end
  end

  defp eliminar_producto(inventario) do
    codigo = IO.gets("Código del producto: ") |> String.trim()

    case Inventario.eliminar(inventario, codigo) do
      {:ok, inventario_actualizado} ->
        ArchivoJSON.guardar(inventario_actualizado)
        IO.puts("Producto eliminado")
        inventario_actualizado

      {:error, mensaje} ->
        IO.puts(mensaje)
        inventario
    end
  end

  defp ejecutar_consultas(inventario) do
    IO.puts("""
    a) Productos con dos vocales
    b) Productos que empiezan y terminan igual
    c) Productos con precio menor
    d) Tres productos más caros
    e) Productos entre precios
    f) Agrupar por rango de precio
    """)

    opcion = IO.gets("Seleccione una opción: ") |> String.trim()

    case opcion do
      "a" ->
        IO.inspect(Inventario.productos_con_dos_vocales(inventario))

      "b" ->
        IO.inspect(Inventario.productos_misma_letra(inventario))

      "c" ->
        precio_limite =
          IO.gets("Ingrese precio límite: ")
          |> String.trim()
          |> String.to_integer()

        IO.inspect(Inventario.productos_precio_menor(inventario, precio_limite))

      "d" ->
        IO.inspect(Inventario.tres_productos_mas_caros(inventario))

      "e" ->
        precio_minimo =
          IO.gets("Precio mínimo: ")
          |> String.trim()
          |> String.to_integer()

        precio_maximo =
          IO.gets("Precio máximo: ")
          |> String.trim()
          |> String.to_integer()

        IO.puts(
          Inventario.productos_entre_precios(
            inventario,
            precio_minimo,
            precio_maximo
          )
        )

      "f" ->
        IO.inspect(Inventario.agrupar_productos_por_precio(inventario))

      _ ->
        IO.puts("Opción inválida")
    end
  end
end
