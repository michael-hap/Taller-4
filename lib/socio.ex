defmodule GimnasioApp.Socio do
  @enforce_keys [:cedula, :nombre, :edad]
  defstruct [:cedula, :nombre, :edad, clases: []]

  def nuevo(cedula, nombre, edad) when edad > 0 do
    {:ok, %__MODULE__{cedula: cedula, nombre: nombre, edad: edad}}
  end

  def nuevo(_cedula, _nombre, _edad) do
    {:error, :edad_invalida}
  end

  
end
