defmodule GimnasioApp.Socio do
  @enforce_keys [:cedula, :nombre, :edad]
  defstruct [:cedula, :nombre, :edad, clases: []]

  def nuevo(cedula, nombre, edad) when edad > 0 do
    {:ok, %__MODULE__{cedula: cedula, nombre: nombre, edad: edad}}
  end

  def nuevo(_cedula, _nombre, _edad) do
    {:error, :edad_invalida}
  end

  def inscribir_clase(%__MODULE__{clases: clases} = socio, clase) do
    if Enum.member?(clases, clase) do
      {:error, :clase_duplicada}
    else
      socio_actualizado = %{socio | clases: [clase | clases]}
      {:ok, socio_actualizado}
    end
  end

  def desinscribir_clase(%__MODULE__{clases: clases} = socio, clase) do
    socio_actualizado = %{socio | clases: List.delete(clases,clase)}
    {:ok, socio_actualizado}
  end

  def listar_clases(%__MODULE__{clases: clases}) do
    {:ok, clases}
  end
end
