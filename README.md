# GimnasioApp

Proyecto desarrollado en Elixir con Mix Application para gestionar socios de un gimnasio.

## Descripción

El sistema permite crear, eliminar, buscar y listar socios. También permite inscribir y desinscribir socios en clases, listar socios inscritos en una clase específica y listar las clases de un socio por su cédula.

Los datos se manejan usando un `Map`, donde la clave es la cédula y el valor es un struct `Socio`.

## Módulos

- `GimnasioApp.Socio`: define el struct del socio y sus validaciones.
- `GimnasioApp.Gimnasio`: contiene la lógica de negocio del sistema.
- `GimnasioApp.GestionArchivos`: maneja la lectura y escritura del archivo `socios.csv`.
- `GimnasioApp.Menu`: permite interactuar con el sistema desde consola.

## Funcionalidades

1. Crear un socio.
2. Eliminar un socio.
3. Inscribir a un socio en una clase.
4. Desinscribir a un socio de una clase.
5. Buscar un socio por cédula.
6. Listar todos los socios.
7. Listar socios inscritos en una clase específica.
8. Listar todas las clases de un socio dada su cédula.

## Persistencia

El sistema utiliza el archivo `socios.csv` con el siguiente formato:

```csv
cedula,nombre,edad,clases
123,Juan Pérez,30,Yoga;Pilates
456,Ana García,25,CrossFit;Yoga

Para la ejecución desde consola se usa el comando iex.bat -S mix

Para compilar el proyecto se usa mix compile

Desde la consola de elixir ejecutar: GimnasioApp.Menu.iniciar() para abrir el menu

Las funciones principales retornan tuplas con el formato:
{:ok, resultado}
{:error, motivo}

Aprendizajes:
Durante el desarrollo del taller se reforzó el uso de structs, maps, pattern matching, funciones con retorno {:ok, resultado} y {:error, motivo}, además de la lectura y escritura de archivos CSV en Elixir.

Uso de IA: Se usa la IA como apoyo y sobretodo guia porque los temas son extensos y complejos (a percepción nuestra), sin embargo es utilizada en pro aprendizaje.