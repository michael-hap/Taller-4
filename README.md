# Taller 4 - Structs, Mapas y Manejo de Archivos en Elixir

Proyecto desarrollado en Elixir con Mix Application para resolver los ejercicios del taller.

Estudiantes: Michael Acevedo, Santiago Velasquez, Leandro Ortegon

## Ejercicio 1: Gimnasio

El sistema permite crear, eliminar, buscar y listar socios. También permite inscribir y desinscribir socios en clases, listar socios inscritos en una clase específica y listar las clases de un socio por su cédula.

Los datos se manejan usando un `Map`, donde la clave es la cédula y el valor es un struct `Socio`.

### Módulos principales

- `GimnasioApp.Socio`: struct del socio y validaciones.
- `GimnasioApp.Gimnasio`: lógica de negocio.
- `GimnasioApp.GestionArchivos`: lectura y escritura del archivo `socios.csv`.
- `GimnasioApp.Menu`: menú por consola.

## Ejercicio 2: Sistema de inventario de productos

El sistema permite gestionar productos usando un `Map`, donde la clave es el código del producto y el valor es un struct `Producto`.

Cada producto tiene:

- Código
- Nombre
- Precio
- Cantidad

### Módulos principales

- `Producto`: define el struct del producto y sus validaciones.
- `Inventario`: contiene la lógica de negocio y las consultas con `Enum`.
- `ArchivoJSON`: maneja la persistencia en el archivo `data/json/productos.json` usando la librería `Jason`.
- `Menu`: permite interactuar con el inventario desde consola.

### Funcionalidades

1. Agregar producto.
2. Actualizar producto.
3. Eliminar producto.
4. Listar productos.
5. Consultar productos cuyo nombre tenga al menos dos vocales.
6. Consultar productos cuyo nombre comience y termine con la misma letra.
7. Consultar productos por debajo de un precio dado.
8. Consultar los tres productos más caros.
9. Consultar productos entre dos precios y retornarlos como cadena.
10. Agrupar productos por rango de precio.

### Validaciones

- No se permiten códigos repetidos.
- El código debe tener máximo 5 caracteres.
- El nombre solo puede contener letras y espacios.
- El precio debe ser mayor o igual a 0.
- La cantidad debe ser un número entero mayor o igual a 0.

### Persistencia

El inventario se guarda en:

```text
data/json/productos.json
```

Se carga automáticamente al iniciar el menú y se guarda automáticamente después de agregar, actualizar o eliminar productos.

## Comandos de ejecución

Instalar dependencias:

```bash
mix deps.get
```

Compilar:

```bash
mix compile
```

Ejecutar pruebas:

```bash
mix test
```

Abrir consola interactiva:

```bash
iex -S mix
```

Iniciar menú del ejercicio 1:

```elixir
GimnasioApp.Menu.iniciar()
```

Iniciar menú del ejercicio 2:

```elixir
Menu.iniciar()
```

## Manejo de errores

Las funciones principales retornan tuplas con el formato:

```elixir
{:ok, resultado}
{:error, motivo}
```

## Aprendizajes

Durante el desarrollo del taller se reforzó el uso de structs, maps, pattern matching, funciones con retorno `{:ok, resultado}` y `{:error, motivo}`, uso de `Enum` para consultas funcionales y lectura/escritura de archivos CSV y JSON en Elixir.

## Uso de inteligencia artificial

La inteligencia artificial se utilizó como apoyo para revisar estructura, validar errores, organizar módulos y comprender mejor el uso de structs, maps, persistencia y manejo de errores en Elixir. El desarrollo final fue revisado y adaptado según los requerimientos del taller.
