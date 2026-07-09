package ar.edu.ubp.das.ristorino_backend.services.clientes.Dto;

import java.util.List;

public class RegistrarClienteRequestDTO {

  private String correo;
  private String nombre;
  private String apellido;
  private Integer dni;
  private String telefono;
  private Integer nroLocalidad;
  private String password;
  private List<PreferenciaSeleccionadaDTO> preferencias;

  public RegistrarClienteRequestDTO() {
  }

  public String getCorreo() {
    return correo;
  }

  public void setCorreo(String correo) {
    this.correo = correo;
  }

  public String getNombre() {
    return nombre;
  }

  public void setNombre(String nombre) {
    this.nombre = nombre;
  }

  public String getApellido() {
    return apellido;
  }

  public void setApellido(String apellido) {
    this.apellido = apellido;
  }

  public Integer getDni() {
    return dni;
  }

  public void setDni(Integer dni) {
    this.dni = dni;
  }

  public String getTelefono() {
    return telefono;
  }

  public void setTelefono(String telefono) {
    this.telefono = telefono;
  }

  public Integer getNroLocalidad() {
    return nroLocalidad;
  }

  public void setNroLocalidad(Integer nroLocalidad) {
    this.nroLocalidad = nroLocalidad;
  }

  public String getPassword() {
    return password;
  }

  public void setPassword(String password) {
    this.password = password;
  }

  public List<PreferenciaSeleccionadaDTO> getPreferencias() {
    return preferencias;
  }

  public void setPreferencias(List<PreferenciaSeleccionadaDTO> preferencias) {
    this.preferencias = preferencias;
  }
}
