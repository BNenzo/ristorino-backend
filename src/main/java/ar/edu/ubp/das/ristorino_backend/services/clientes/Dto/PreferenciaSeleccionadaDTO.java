package ar.edu.ubp.das.ristorino_backend.services.clientes.Dto;

public class PreferenciaSeleccionadaDTO {

  private String cod_categoria;
  private Integer nro_valor_dominio;

  public PreferenciaSeleccionadaDTO() {
  }

  public String getCod_categoria() {
    return cod_categoria;
  }

  public void setCod_categoria(String cod_categoria) {
    this.cod_categoria = cod_categoria;
  }

  public Integer getNro_valor_dominio() {
    return nro_valor_dominio;
  }

  public void setNro_valor_dominio(Integer nro_valor_dominio) {
    this.nro_valor_dominio = nro_valor_dominio;
  }
}
