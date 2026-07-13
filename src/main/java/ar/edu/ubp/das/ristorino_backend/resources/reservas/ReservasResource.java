package ar.edu.ubp.das.ristorino_backend.resources.reservas;

import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import ar.edu.ubp.das.ristorino_backend.components.ApiHandler.ApiHandler;
import ar.edu.ubp.das.ristorino_backend.config.beans.ConfigBean;
import ar.edu.ubp.das.ristorino_backend.repositories.configuracion.ConfiguracionRepository;
import ar.edu.ubp.das.ristorino_backend.repositories.reservas.ReservasRepository;
import ar.edu.ubp.das.ristorino_backend.repositories.reservas.beans.ObtenerDisponibilidadTurnosResponseBean;
import ar.edu.ubp.das.ristorino_backend.resources.reservas.beans.CrearReservaRequestBean;
import ar.edu.ubp.das.ristorino_backend.resources.reservas.beans.ObtenerReservaClienteBean;
import ar.edu.ubp.das.ristorino_backend.resources.reservas.beans.ObtenerSucursalesFormReservasResponseBean;
import ar.edu.ubp.das.ristorino_backend.services.reservas.ReservasService;
import ar.edu.ubp.das.ristorino_backend.services.reservas.Dto.CrearReservaDesdeRistorinoResponseDTO;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import ar.edu.ubp.das.ristorino_backend.repositories.reservas.beans.ObtenerEstadosIdiomaBean;
import ar.edu.ubp.das.ristorino_backend.repositories.reservas.beans.ObtenerReservasClienteBean;
import ar.edu.ubp.das.ristorino_backend.repositories.reservas.beans.ObtenerZonasSucursalesRestaurantesFormReservasResponseBean;

import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;
import com.google.gson.JsonObject;
import com.google.gson.reflect.TypeToken;

@RestController
@RequestMapping("/ristorino")

public class ReservasResource {

  @Autowired
  private ReservasRepository reservasRepository;
  @Autowired
  private ReservasService reservasService;
  @Autowired
  private ConfiguracionRepository configuracionRepository;

  // GET DISPONIBILIDAD DE TURNOS (POR NRO_RESTAURANTE, SUCURSAL Y FECHA)
  @GetMapping("/reservas/disponibilidad-v2")
  public List<ObtenerDisponibilidadTurnosResponseBean> obtenerDisponibilidadDeTurnosV2(
      @RequestParam Integer nroRestaurante,
      @RequestParam Integer nroSucursal,
      @RequestParam String codZona,
      @RequestParam String fechaAReservar) {
    ConfigBean config = configuracionRepository.obtenerConfiguracionRestaunte(nroRestaurante);

    JsonObject body = new JsonObject();
    body.addProperty("nroSucursal", nroSucursal);
    body.addProperty("codZona", codZona);
    body.addProperty("fechaAReservar", fechaAReservar);

    return new ApiHandler(config, "ObtenerDisponibilidadHorariaZona").execute(body,
        new TypeToken<List<ObtenerDisponibilidadTurnosResponseBean>>() {
        }.getType());
  }

  // 1) craer la reserva en el restaurante -> ApiHandler
  // 2) crear la reserva en ristorino -> repository
  // 3) retornar codigo de reserva.
  // =====================================
  // REALIZAR UNA RESERVA EN UNA SUCURSAL
  // =====================================
  @PostMapping("/reservas/crear-reserva")
  public ResponseEntity<CrearReservaDesdeRistorinoResponseDTO> crearReserva(
      @RequestHeader(value = "nroCliente") Integer nroCliente,
      @RequestBody CrearReservaRequestBean request) {

    CrearReservaDesdeRistorinoResponseDTO response = reservasService.crearReserva(request, nroCliente);
    return ResponseEntity.ok(response);
  }

  // GET LAS RESERVAS DE UN CLIENTE
  @GetMapping("/reservas/cliente")
  public List<ObtenerReservasClienteBean> obtenerReservasCliente(
      @RequestHeader(value = "nroCliente") Integer nroCliente,
      @RequestHeader(value = "nroIdioma", required = false) Integer nroIdioma,
      @RequestParam(value = "fecha", required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fecha,
      @RequestParam(value = "estados", required = false) List<String> estados) {
    return reservasRepository.obtenerReservasCliente(nroCliente, nroIdioma, fecha, estados);
  }

  // OBTENER LOS ESTADOS POSIBLES DE UNA RESERVA EN UN IDIOMA EN PARTICULAR
  @GetMapping("/reservas/estados")
  public List<ObtenerEstadosIdiomaBean> obtenerEstadosDeReservaPorIdioma(
      @RequestHeader(value = "nroIdioma", required = false) Integer nroIdioma) {
    return reservasRepository.obtenerEstadosDeReservaPorIdioma(nroIdioma);
  }

  // OBTENER LA RESERVA DE UN CLIENTE
  @GetMapping("/reservas/cliente/{nro_reserva}")
  public ObtenerReservaClienteBean obtenerReservaCliente(
      @PathVariable("nro_reserva") Integer nroReserva,
      @RequestHeader(value = "nroCliente") Integer nroCliente) {
    return reservasRepository.obtenerReservaCliente(nroCliente, nroReserva);
  }

  // OBTENER SUCURSALES PARA INICIALIZAR EL FORM DE RESERVAS
  @GetMapping("/reservas/obtener-sucursales")
  public List<ObtenerSucursalesFormReservasResponseBean> obtenerSucursalesFromReservas() {
    return reservasRepository.obtenerSucursalesFormReservas();
  }

  /*
   * OBTENER LAS ZONAS DISPONIBLES DE UNA SUCURSAL DE UN RESTAURANTE PARA
   * INICIALIZAR EL FORM DE RESERVA
   */
  @GetMapping("/reservas/obtener-zonas-sucursales-restaurantes")
  public List<ObtenerZonasSucursalesRestaurantesFormReservasResponseBean> obtenerZonasDeSucursalesRestaurantesFormReservas(
      @RequestHeader(value = "nroIdioma", required = false) Integer nroIdioma) {
    return reservasRepository.obtenerZonasDeSucursalesRestaurantesFormReservas(nroIdioma);
  }

}
