package ar.edu.ubp.das.ristorino_backend.repositories.preferencias;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.stereotype.Repository;

import ar.edu.ubp.das.ristorino_backend.beans.preferencias.ObtenerPreferenciasClienteResponseBean;
import ar.edu.ubp.das.ristorino_backend.beans.preferencias.ObtenerPreferenciasSucursalRestauranteResponseBean;
import ar.edu.ubp.das.ristorino_backend.beans.preferencias.PreferenciaResponseBean;
import ar.edu.ubp.das.ristorino_backend.components.SimpleJdbcCallFactory;

@Repository
public class PreferenciaRepository {

  @Autowired
  private SimpleJdbcCallFactory jdbcCallFactory;

  // ==================================
  // OBTENER PREFERENCIAS GASTRONÓMICAS
  // ==================================
  public List<PreferenciaResponseBean> obtenerPreferenciasGastronomicas() {

    return jdbcCallFactory.executeQuery(
        "sp_get_preferencias_gastronomicas",
        "dbo",
        "preferencias",
        PreferenciaResponseBean.class);
  }

  public List<ObtenerPreferenciasSucursalRestauranteResponseBean> obtenerPreferenciasSucursalRestaurante() {
    MapSqlParameterSource p = new MapSqlParameterSource()
        .addValue("nro_idioma", 1);

    return jdbcCallFactory.executeQuery(
        "sp_get_restaurantes_tags_flat",
        "dbo",
        p,
        "preferencias_restaurantes",
        ObtenerPreferenciasSucursalRestauranteResponseBean.class);
  }

  // ==================================
  // OBTENER PREFERENCIAS DEL CLIENTE (tags planos)
  // ==================================
  public String obtenerPreferenciasClienteTags(Integer nroCliente, Integer nroIdioma) {
    MapSqlParameterSource p = new MapSqlParameterSource()
        .addValue("nro_cliente", nroCliente)
        .addValue("nro_idioma", nroIdioma != null ? nroIdioma : 1);

    List<ObtenerPreferenciasClienteResponseBean> result = jdbcCallFactory.executeQuery(
        "sp_get_preferencias_cliente_tags_flat",
        "dbo",
        p,
        "preferencias_cliente",
        ObtenerPreferenciasClienteResponseBean.class);

    return result.isEmpty() ? null : result.get(0).getTags();
  }
}
