package ar.edu.ubp.das.ristorino_backend.services.contenidos;

import java.lang.reflect.Type;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import ar.edu.ubp.das.ristorino_backend.beans.ContenidoNoPublicadoBean;
import ar.edu.ubp.das.ristorino_backend.beans.RestauranteIdBean;
import ar.edu.ubp.das.ristorino_backend.beans.contenidos.ActualizarContenidosNoPublicadosDTO;
import ar.edu.ubp.das.ristorino_backend.beans.contenidos.BuscadoPromocionesIAOutput;
import ar.edu.ubp.das.ristorino_backend.beans.contenidos.BuscadorPromocionesIAInputDTO;
import ar.edu.ubp.das.ristorino_backend.beans.contenidos.BuscarContenidosIAResponseBean;
import ar.edu.ubp.das.ristorino_backend.beans.contenidos.ObtenerContenidosResponseBean;
import ar.edu.ubp.das.ristorino_backend.beans.idiomas.IdiomasResponseBean;
import ar.edu.ubp.das.ristorino_backend.beans.preferencias.ObtenerPreferenciasSucursalRestauranteResponseBean;
import ar.edu.ubp.das.ristorino_backend.components.AI.genIA.GenAI;
import ar.edu.ubp.das.ristorino_backend.components.AI.genIA.SystemPrompts;
import ar.edu.ubp.das.ristorino_backend.components.ApiHandler.ApiHandler;
import ar.edu.ubp.das.ristorino_backend.config.beans.ConfigBean;
import ar.edu.ubp.das.ristorino_backend.repositories.configuracion.ConfiguracionRepository;
import ar.edu.ubp.das.ristorino_backend.repositories.contenidos.ContenidosRepository;
import ar.edu.ubp.das.ristorino_backend.repositories.contenidos.beans.ObtenerContenidosSinContenidosIABean;
import ar.edu.ubp.das.ristorino_backend.repositories.costos.CostosRepository;
import ar.edu.ubp.das.ristorino_backend.repositories.idiomas.IdiomasRepository;
import ar.edu.ubp.das.ristorino_backend.repositories.preferencias.PreferenciaRepository;
import ar.edu.ubp.das.ristorino_backend.resources.contenidos.beans.BuscarPromocionesIARequestBean;

@Service
public class ContenidosService {
  @Autowired
  private ConfiguracionRepository configuracionRepository;
  @Autowired
  private ContenidosRepository contenidosRepository;
  @Autowired
  private IdiomasRepository idiomasRepository;
  @Autowired
  private PreferenciaRepository preferenciaRepository;
  @Autowired
  private CostosRepository costosRepository;

  @Autowired
  private GenAI genAI;

  private static final Gson GSON = new Gson();

  public ContenidosService() {
  }

  /*
   * METODO ORQUESTADOR PARA OBTENER TODOS LOS CONTENIDOS NO PUBLICADOS,
   * GUARDARLOS EN DB Y
   * SOLICITAR ACTUALIZACION DE LOS RESTAURANTES
   */
  public void sincronizarContenidosNoPublicados() {

    List<ContenidoNoPublicadoBean> contenidos = this.obtenerTodosLosContenidosNoPublicados();

    if (contenidos == null || contenidos.isEmpty()) {
      return;
    }

    // Obtener costo dinámico UNA sola vez
    BigDecimal costoContenido = costosRepository
        .obtenerCostoPorTipo("CONTENIDO")
        .getMonto();

    for (ContenidoNoPublicadoBean c : contenidos) {

      c.setCostoClick(costoContenido);

      contenidosRepository.insertarContenidoNoPublicado(c);
    }

    this.actualizarContenidoNoPublicadosAPublicados(contenidos);
  }

  public List<ContenidoNoPublicadoBean> obtenerTodosLosContenidosNoPublicados() {

    List<ContenidoNoPublicadoBean> resultado = new ArrayList<>();

    // 1) Obtenemos restaurantes desde DB ristorino
    List<RestauranteIdBean> restaurantes = contenidosRepository.getRestaurantesId();

    // 2) Recorremos cada restaurante
    for (RestauranteIdBean r : restaurantes) {

      int nroRestaurante = r.getNro_restaurante();

      // 3) Obtenemos la configuración
      ConfigBean config = configuracionRepository.obtenerConfiguracionRestaunte(nroRestaurante);

      List<ContenidoNoPublicadoBean> contenidosPorRestaurante;

      // 4) Decidir backend
      contenidosPorRestaurante = new ApiHandler(config,
          "ObtenerContenidosNoPublicados")
          .execute(new TypeToken<List<ContenidoNoPublicadoBean>>() {
          }.getType());

      // 5) Normalizar y unificar resultados
      if (contenidosPorRestaurante != null && !contenidosPorRestaurante.isEmpty()) {

        for (ContenidoNoPublicadoBean c : contenidosPorRestaurante) {

          // 🔥 PISAMOS el nro_restaurante con el de ristorino
          c.setNroRestaurante(nroRestaurante);

          resultado.add(c);
        }
      }
    }

    return resultado;
  }

  // ACTUALIZAR LOS CONTENIDOS NO PUBLICADOS A PUBLICADOS
  public void actualizarContenidoNoPublicadosAPublicados(List<ContenidoNoPublicadoBean> contenidos) {

    if (contenidos == null || contenidos.isEmpty()) {
      return;
    }

    // 1) Agrupamos todos los contenidos por nroRestaurante, para poder recorrer
    // esto en un array y mandar todos los contenidos a actualizar en la misma
    // request
    Map<Integer, List<ContenidoNoPublicadoBean>> contenidosPorRestaurante = contenidos.stream()
        .collect(Collectors.groupingBy(ContenidoNoPublicadoBean::getNroRestaurante));

    // 2) Recorremos los lotes de restaurantes - contenido.
    for (Map.Entry<Integer, List<ContenidoNoPublicadoBean>> entry : contenidosPorRestaurante.entrySet()) {

      Integer nroRestaurante = entry.getKey();
      List<ContenidoNoPublicadoBean> listaContenidos = entry.getValue();

      ConfigBean config = configuracionRepository.obtenerConfiguracionRestaunte(nroRestaurante);

      // 3) cargamos la lista de contenidos en un nuevo dto para poder enviarlo en el
      // body de la request

      // otra forma de hacerlo:
      // JsonObject body = new JsonObject();
      // body.add("contenidos", GSON.toJsonTree(listaContenidos));

      ActualizarContenidosNoPublicadosDTO actualizarContenidosNoPublicadosBody = new ActualizarContenidosNoPublicadosDTO();
      actualizarContenidosNoPublicadosBody.setContenidos(listaContenidos);

      new ApiHandler(config,
          "ActualizarContenidoNoPublicadoAPublicados")
          .execute(actualizarContenidosNoPublicadosBody);
    }
  }

  public List<ObtenerContenidosSinContenidosIABean> generarContenidosIA()
      throws JsonProcessingException {
    List<ObtenerContenidosSinContenidosIABean> promociones = contenidosRepository.obtenerContenidosSinContenidosIA();

    if (promociones.size() == 0) {
      return null;
    }

    List<IdiomasResponseBean> idiomas = idiomasRepository.obtenerIdiomas();

    int chunkSize = 3;
    List<ObtenerContenidosSinContenidosIABean> resultAll = new ArrayList<>();

    for (int i = 0; i < promociones.size(); i += chunkSize) {
      List<ObtenerContenidosSinContenidosIABean> chunk = promociones.subList(i,
          Math.min(i + chunkSize, promociones.size()));

      ObjectMapper om = new ObjectMapper();
      om.registerModule(new JavaTimeModule());
      om.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);

      Map<String, Object> input = new LinkedHashMap<>();
      input.put("idiomas", idiomas);
      input.put("contenidos", chunk);

      String inputString = om.writeValueAsString(input);

      String text = genAI.generate(inputString, SystemPrompts.RESTAURANTE_MULTILINGUE);

      List<ObtenerContenidosSinContenidosIABean> list = om.readValue(text,
          new TypeReference<List<ObtenerContenidosSinContenidosIABean>>() {
          });

      for (ObtenerContenidosSinContenidosIABean item : list) {
        contenidosRepository.insertarContenidoGeneradoConIA(item);
      }

      resultAll.addAll(list);

    }

    return resultAll;
  }

  public List<BuscarContenidosIAResponseBean> buscarContenidosConIA(BuscarPromocionesIARequestBean search,
      Integer nroIdioma, Integer nroCliente)
      throws JsonProcessingException {

    List<ObtenerContenidosResponseBean> promociones = contenidosRepository.getPromociones(null, nroIdioma);

    List<ObtenerPreferenciasSucursalRestauranteResponseBean> preferenciasRestaurantesSucursales = preferenciaRepository
        .obtenerPreferenciasSucursalRestaurante();
    List<BuscadorPromocionesIAInputDTO> promosDTO = promociones.stream()
        .map(p -> new BuscadorPromocionesIAInputDTO(
            p.getNroRestaurante() + "-"
                + p.getNroContenido() + "-"
                + p.getNroIdioma(),
            p.getContenidoAPublicar()))
        .toList();

    Map<String, Object> input = new LinkedHashMap<>();
    input.put("search", search.getSearch());
    input.put("promociones", promosDTO);
    input.put("restaurantes", preferenciasRestaurantesSucursales);

    if (nroCliente != null) {
      String preferenciasCliente = preferenciaRepository.obtenerPreferenciasClienteTags(nroCliente, nroIdioma);
      input.put("preferenciasCliente", preferenciasCliente);
    }

    String inputString = new Gson().toJson(input);
    String text = genAI.generate(inputString, SystemPrompts.PROMO_SEARCH);

    Type listType = new TypeToken<List<BuscadoPromocionesIAOutput>>() {
    }.getType();
    List<BuscadoPromocionesIAOutput> list = GSON.fromJson(text, listType);

    return contenidosRepository.obtenerContenidosPorListaDeContenidosIds(list);
  }

}
