package ar.edu.ubp.das.ristorino_backend.resources.contenidos;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import ar.edu.ubp.das.ristorino_backend.beans.ContenidoNoPublicadoBean;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import ar.edu.ubp.das.ristorino_backend.beans.contenidos.BuscarContenidosIAResponseBean;
import ar.edu.ubp.das.ristorino_backend.beans.contenidos.ObtenerContenidosResponseBean;
import ar.edu.ubp.das.ristorino_backend.beans.idiomas.IdiomasResponseBean;
import ar.edu.ubp.das.ristorino_backend.components.AI.genIA.GenAI;
import ar.edu.ubp.das.ristorino_backend.components.AI.genIA.SystemPrompts;
import ar.edu.ubp.das.ristorino_backend.repositories.contenidos.ContenidosRepository;
import ar.edu.ubp.das.ristorino_backend.services.contenidos.ContenidosService;
import ar.edu.ubp.das.ristorino_backend.repositories.contenidos.beans.ObtenerContenidosSinContenidosIABean;
import ar.edu.ubp.das.ristorino_backend.repositories.idiomas.IdiomasRepository;
import ar.edu.ubp.das.ristorino_backend.resources.contenidos.beans.BuscarPromocionesIARequestBean;
import org.springframework.web.bind.annotation.RequestBody;

@RestController
@RequestMapping("/ristorino")
public class ContenidosResource {
  @Autowired
  private ContenidosRepository contenidosRepository;
  @Autowired
  private ContenidosService contenidosService;

  @Autowired
  private IdiomasRepository idiomasRepository;

  @Autowired
  private GenAI genAI;

  /*
   * ------------------------
   * OBTENER TODOS LOS CONTENIDOS PUBLICADOS -> Se llama para cargar los
   * contenidos en la home page
   * ------------------------
   */
  @GetMapping("/promociones")
  public ResponseEntity<List<ObtenerContenidosResponseBean>> obtenerPromociones(
      @RequestParam(name = "nroRestaurante", required = false) Integer nroRestaurante,
      @RequestHeader(value = "nroIdioma", required = false) Integer nroIdioma

  ) {
    List<ObtenerContenidosResponseBean> promociones = contenidosRepository.getPromociones(nroRestaurante, nroIdioma);
    return ResponseEntity.ok(promociones);
  }

  /*
   * Obtener contenidos en base a la entrada de un input del usuario
   */
  @PostMapping("/contenidos/busqueda")
  public ResponseEntity<List<BuscarContenidosIAResponseBean>> buscarContenidosIA(
      @RequestBody BuscarPromocionesIARequestBean request,
      @RequestHeader(value = "nroIdioma", required = false) Integer nroIdioma,
      @RequestHeader(value = "nroCliente", required = false) Integer nroCliente)
      throws JsonProcessingException {
    return ResponseEntity.ok(contenidosService.buscarContenidosConIA(request, nroIdioma, nroCliente));
  }

  /*
   * Obtener contenidos no publicados de restaurantes, guardarlos y actualizar el
   * publicado
   */
  @PostMapping("/contenidos/sincronizar")
  public ResponseEntity<String> sincronizarContenidos() {
    contenidosService.sincronizarContenidosNoPublicados();
    return ResponseEntity.ok("contenidos sincronizados correctamente");
  }

  @GetMapping("/test-promociones")
  public ResponseEntity<List<ObtenerContenidosSinContenidosIABean>> obtenerContenidosSinContenidosIA()
      throws JsonProcessingException {
    List<ObtenerContenidosSinContenidosIABean> promociones = contenidosRepository.obtenerContenidosSinContenidosIA();
    List<IdiomasResponseBean> idiomas = idiomasRepository.obtenerIdiomas();

    ObjectMapper om = new ObjectMapper();
    om.registerModule(new JavaTimeModule());
    om.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);

    Map<String, Object> input = new LinkedHashMap<>();
    input.put("idiomas", idiomas);
    input.put("contenidos", promociones);

    String inputString = om.writeValueAsString(input);

    String text = genAI.generate(inputString, SystemPrompts.RESTAURANTE_MULTILINGUE);

    List<ObtenerContenidosSinContenidosIABean> list = om.readValue(text,
        new TypeReference<List<ObtenerContenidosSinContenidosIABean>>() {
        });

    for (ObtenerContenidosSinContenidosIABean item : list) {
      contenidosRepository.insertarContenidoGeneradoConIA(item);
    }

    return ResponseEntity.ok(list);
  }

  // Endpoint de prueba nomas . . . borrar luego
  @GetMapping("/contenidos/no-publicados")
  public ResponseEntity<List<ContenidoNoPublicadoBean>> obtenerContenidosNoPublicados() {

    List<ContenidoNoPublicadoBean> contenidos = contenidosService.obtenerTodosLosContenidosNoPublicados();

    return ResponseEntity.ok(contenidos);
  }

}
