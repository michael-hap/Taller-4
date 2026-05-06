defmodule Menu do
  def iniciar do
    inventario = cargar_inventario()
    ejecutar_menu(inventario)
  end

  defp cargar_inventario do
    case ArchivoJSON.cargar() do
      {:ok, inventario} ->
        inventario

      {:error, razon} ->
        IO.puts("No se pudo cargar el archivo: #{inspect(razon)}")
        %{}
    end
  end

  defp ejecutar_menu(inventario) do
    IO.puts("""

    ===== MENÚ INVENTARIO =====
    1. Agregar producto
    2. Listar productos
    3. Actualizar producto
    4. Eliminar producto
    5. Productos con al menos dos vocales
    6. Productos que comienzan y terminan con la misma letra
    7. Productos por debajo de un precio
    8. Tres productos más caros
    9. Productos entre dos precios
    10. Agrupar productos por rango de precio
    0. Salir
    """)

    opcion = IO.gets("Seleccione una opción: ") |> String.trim()

    case opcion do
      "1" -> inventario |> agregar_producto() |> ejecutar_menu()
      "2" -> listar_productos(inventario); ejecutar_menu(inventario)
      "3" -> inventario |> actualizar_producto() |> ejecutar_menu()
      "4" -> inventario |> eliminar_producto() |> ejecutar_menu()
      "5" -> IO.inspect(Inventario.productos_con_dos_vocales(inventario)); ejecutar_menu(inventario)
      "6" -> IO.inspect(Inventario.productos_misma_letra(inventario)); ejecutar_menu(inventario)
      "7" -> consultar_precio_menor(inventario); ejecutar_menu(inventario)
      "8" -> IO.inspect(Inventario.tres_productos_mas_caros(inventario)); ejecutar_menu(inventario)
      "9" -> consultar_entre_precios(inventario); ejecutar_menu(inventario)
      "10" -> IO.inspect(Inventario.agrupar_productos_por_precio(inventario)); ejecutar_menu(inventario)
      "0" -> IO.puts("Saliendo...")
      _ -> IO.puts("Opción inválida"); ejecutar_menu(inventario)
    end
  end

  defp agregar_producto(inventario) do
    codigo = pedir_texto("Código: ")
    nombre = pedir_texto("Nombre: ")

    with {:ok, precio} <- pedir_numero("Precio: "),
         {:ok, cantidad} <- pedir_entero("Cantidad: "),
         {:ok, producto} <- Producto.crear(codigo, nombre, precio, cantidad),
         {:ok, inventario_actualizado} <- Inventario.agregar(inventario, producto),
         {:ok, :guardado} <- ArchivoJSON.guardar(inventario_actualizado) do
      IO.puts("Producto agregado correctamente")
      inventario_actualizado
    else
      {:error, razon} ->
        IO.puts("Error: #{inspect(razon)}")
        inventario
    end
  end

  defp actualizar_producto(inventario) do
    codigo = pedir_texto("Código del producto: ")

    IO.puts("Deje vacío un campo si no desea cambiarlo.")
    nuevo_codigo = pedir_texto("Nuevo código: ")
    nuevo_nombre = pedir_texto("Nuevo nombre: ")
    nuevo_precio = pedir_texto("Nuevo precio: ")
    nueva_cantidad = pedir_texto("Nueva cantidad: ")

    with {:ok, datos} <- construir_datos_actualizacion(nuevo_codigo, nuevo_nombre, nuevo_precio, nueva_cantidad),
         {:ok, inventario_actualizado} <- Inventario.actualizar(inventario, codigo, datos),
         {:ok, :guardado} <- ArchivoJSON.guardar(inventario_actualizado) do
      IO.puts("Producto actualizado correctamente")
      inventario_actualizado
    else
      {:error, razon} ->
        IO.puts("Error: #{inspect(razon)}")
        inventario
    end
  end

  defp eliminar_producto(inventario) do
    codigo = pedir_texto("Código del producto: ")

    with {:ok, inventario_actualizado} <- Inventario.eliminar(inventario, codigo),
         {:ok, :guardado} <- ArchivoJSON.guardar(inventario_actualizado) do
      IO.puts("Producto eliminado correctamente")
      inventario_actualizado
    else
      {:error, razon} ->
        IO.puts("Error: #{inspect(razon)}")
        inventario
    end
  end

  defp listar_productos(inventario) do
    inventario
    |> Inventario.listar()
    |> Enum.each(fn producto ->
      IO.puts("#{producto.codigo} - #{producto.nombre} - #{producto.precio} - #{producto.cantidad}")
    end)
  end

  defp consultar_precio_menor(inventario) do
    case pedir_numero("Ingrese precio límite: ") do
      {:ok, precio} -> IO.inspect(Inventario.productos_precio_menor(inventario, precio))
      {:error, razon} -> IO.puts("Error: #{inspect(razon)}")
    end
  end

  defp consultar_entre_precios(inventario) do
    with {:ok, minimo} <- pedir_numero("Precio mínimo: "),
         {:ok, maximo} <- pedir_numero("Precio máximo: ") do
      IO.puts(Inventario.productos_entre_precios(inventario, minimo, maximo))
    else
      {:error, razon} -> IO.puts("Error: #{inspect(razon)}")
    end
  end

  defp construir_datos_actualizacion(codigo, nombre, precio, cantidad) do
    with {:ok, precio_convertido} <- convertir_numero_opcional(precio),
         {:ok, cantidad_convertida} <- convertir_entero_opcional(cantidad) do
      datos = %{}
      datos = if codigo == "", do: datos, else: Map.put(datos, :codigo, codigo)
      datos = if nombre == "", do: datos, else: Map.put(datos, :nombre, nombre)
      datos = if precio == "", do: datos, else: Map.put(datos, :precio, precio_convertido)
      datos = if cantidad == "", do: datos, else: Map.put(datos, :cantidad, cantidad_convertida)

      {:ok, datos}
    end
  end

  defp pedir_texto(mensaje), do: IO.gets(mensaje) |> String.trim()

  defp pedir_numero(mensaje) do
    mensaje
    |> pedir_texto()
    |> convertir_numero()
  end

  defp pedir_entero(mensaje) do
    mensaje
    |> pedir_texto()
    |> convertir_entero()
  end

  defp convertir_numero_opcional(""), do: {:ok, nil}
  defp convertir_numero_opcional(valor), do: convertir_numero(valor)

  defp convertir_entero_opcional(""), do: {:ok, nil}
  defp convertir_entero_opcional(valor), do: convertir_entero(valor)

  defp convertir_numero(valor) do
    case Float.parse(valor) do
      {numero, ""} -> {:ok, numero}
      _ -> {:error, :numero_invalido}
    end
  end

  defp convertir_entero(valor) do
    case Integer.parse(valor) do
      {numero, ""} -> {:ok, numero}
      _ -> {:error, :entero_invalido}
    end
  end
end
