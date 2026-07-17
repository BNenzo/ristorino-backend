package ar.edu.ubp.das.ristorino_backend.beans.contenidos;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class ObtenerContenidosResponseBean {

  // Restaurante y geografía
  private int nroRestaurante;
  private String razonSocial;
  private String cuit;
  private Integer nroSucursal;
  private String nomSucursal;
  private String calle;
  private Integer nroCalle;
  private String barrio;
  private String nomLocalidad;
  private String nomProvincia;

  // Contenido
  private int nroContenido;
  private int nroIdioma;
  private String codContenidoRestaurante;
  private String contenidoPromocional;
  private String imagenPromocional;
  private String contenidoAPublicar;
  private LocalDate fechaIniVigencia;
  private LocalDate fechaFinVigencia;
  private BigDecimal costoClick;

  // Métricas de clics (con ISNULL en el SP)
  private int totalClicks;
  private BigDecimal totalCostoClicks;
  private LocalDateTime ultimaInteraccion; // puede ser NULL

  public int getNroRestaurante() {
    return nroRestaurante;
  }

  public void setNroRestaurante(int nroRestaurante) {
    this.nroRestaurante = nroRestaurante;
  }

  public String getRazonSocial() {
    return razonSocial;
  }

  public void setRazonSocial(String razonSocial) {
    this.razonSocial = razonSocial;
  }

  public String getCuit() {
    return cuit;
  }

  public void setCuit(String cuit) {
    this.cuit = cuit;
  }

  public Integer getNroSucursal() {
    return nroSucursal;
  }

  public void setNroSucursal(Integer nroSucursal) {
    this.nroSucursal = nroSucursal;
  }

  public String getNomSucursal() {
    return nomSucursal;
  }

  public void setNomSucursal(String nomSucursal) {
    this.nomSucursal = nomSucursal;
  }

  public String getCalle() {
    return calle;
  }

  public void setCalle(String calle) {
    this.calle = calle;
  }

  public Integer getNroCalle() {
    return nroCalle;
  }

  public void setNroCalle(Integer nroCalle) {
    this.nroCalle = nroCalle;
  }

  public String getBarrio() {
    return barrio;
  }

  public void setBarrio(String barrio) {
    this.barrio = barrio;
  }

  public String getNomLocalidad() {
    return nomLocalidad;
  }

  public void setNomLocalidad(String nomLocalidad) {
    this.nomLocalidad = nomLocalidad;
  }

  public String getNomProvincia() {
    return nomProvincia;
  }

  public void setNomProvincia(String nomProvincia) {
    this.nomProvincia = nomProvincia;
  }

  public int getNroContenido() {
    return nroContenido;
  }

  public void setNroContenido(int nroContenido) {
    this.nroContenido = nroContenido;
  }

  public int getNroIdioma() {
    return nroIdioma;
  }

  public void setNroIdioma(int nroIdioma) {
    this.nroIdioma = nroIdioma;
  }

  public String getCodContenidoRestaurante() {
    return codContenidoRestaurante;
  }

  public void setCodContenidoRestaurante(String codContenidoRestaurante) {
    this.codContenidoRestaurante = codContenidoRestaurante;
  }

  public String getContenidoPromocional() {
    return contenidoPromocional;
  }

  public void setContenidoPromocional(String contenidoPromocional) {
    this.contenidoPromocional = contenidoPromocional;
  }

  public String getImagenPromocional() {
    return imagenPromocional;
  }

  public void setImagenPromocional(String imagenPromocional) {
    this.imagenPromocional = imagenPromocional;
  }

  public String getContenidoAPublicar() {
    return contenidoAPublicar;
  }

  public void setContenidoAPublicar(String contenidoAPublicar) {
    this.contenidoAPublicar = contenidoAPublicar;
  }

  public LocalDate getFechaIniVigencia() {
    return fechaIniVigencia;
  }

  public void setFechaIniVigencia(LocalDate fechaIniVigencia) {
    this.fechaIniVigencia = fechaIniVigencia;
  }

  public LocalDate getFechaFinVigencia() {
    return fechaFinVigencia;
  }

  public void setFechaFinVigencia(LocalDate fechaFinVigencia) {
    this.fechaFinVigencia = fechaFinVigencia;
  }

  public BigDecimal getCostoClick() {
    return costoClick;
  }

  public void setCostoClick(BigDecimal costoClick) {
    this.costoClick = costoClick;
  }

  public int getTotalClicks() {
    return totalClicks;
  }

  public void setTotalClicks(int totalClicks) {
    this.totalClicks = totalClicks;
  }

  public BigDecimal getTotalCostoClicks() {
    return totalCostoClicks;
  }

  public void setTotalCostoClicks(BigDecimal totalCostoClicks) {
    this.totalCostoClicks = totalCostoClicks;
  }

  public LocalDateTime getUltimaInteraccion() {
    return ultimaInteraccion;
  }

  public void setUltimaInteraccion(LocalDateTime ultimaInteraccion) {
    this.ultimaInteraccion = ultimaInteraccion;
  }

}
