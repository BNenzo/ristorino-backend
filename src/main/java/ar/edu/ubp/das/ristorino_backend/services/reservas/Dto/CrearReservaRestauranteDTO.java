package ar.edu.ubp.das.ristorino_backend.services.reservas.Dto;

public class CrearReservaRestauranteDTO {

  private Integer nroCliente;
  private String fechaReserva;
  private Integer nroSucursal;
  private String codZona;
  private String horaReserva;
  private Integer cantAdultos;
  private Integer cantMenores;
  private Double costoReserva;

  public CrearReservaRestauranteDTO() {
  }

  public Integer getNroCliente() {
    return nroCliente;
  }

  public void setNroCliente(Integer nroCliente) {
    this.nroCliente = nroCliente;
  }

  public String getFechaReserva() {
    return fechaReserva;
  }

  public void setFechaReserva(String fechaReserva) {
    this.fechaReserva = fechaReserva;
  }

  public Integer getNroSucursal() {
    return nroSucursal;
  }

  public void setNroSucursal(Integer nroSucursal) {
    this.nroSucursal = nroSucursal;
  }

  public String getCodZona() {
    return codZona;
  }

  public void setCodZona(String codZona) {
    this.codZona = codZona;
  }

  public String getHoraReserva() {
    return horaReserva;
  }

  public void setHoraReserva(String horaReserva) {
    this.horaReserva = horaReserva;
  }

  public Integer getCantAdultos() {
    return cantAdultos;
  }

  public void setCantAdultos(Integer cantAdultos) {
    this.cantAdultos = cantAdultos;
  }

  public Integer getCantMenores() {
    return cantMenores;
  }

  public void setCantMenores(Integer cantMenores) {
    this.cantMenores = cantMenores;
  }

  public Double getCostoReserva() {
    return costoReserva;
  }

  public void setCostoReserva(Double costoReserva) {
    this.costoReserva = costoReserva;
  }
}
