package ar.edu.ubp.das.ristorino_backend.services.reservas;

import java.math.BigDecimal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.google.gson.reflect.TypeToken;

import ar.edu.ubp.das.ristorino_backend.beans.ClienteBean;
import ar.edu.ubp.das.ristorino_backend.components.ApiHandler.ApiHandler;
import ar.edu.ubp.das.ristorino_backend.config.beans.ConfigBean;
import ar.edu.ubp.das.ristorino_backend.repositories.clientes.ClienteRepository;
import ar.edu.ubp.das.ristorino_backend.repositories.configuracion.ConfiguracionRepository;
import ar.edu.ubp.das.ristorino_backend.repositories.costos.CostosRepository;
import ar.edu.ubp.das.ristorino_backend.repositories.reservas.ReservasRepository;
import ar.edu.ubp.das.ristorino_backend.resources.reservas.beans.CrearReservaRequestBean;
import ar.edu.ubp.das.ristorino_backend.services.reservas.Dto.ClienteRestauranteDTO;
import ar.edu.ubp.das.ristorino_backend.services.reservas.Dto.CrearReservaConClienteDTO;
import ar.edu.ubp.das.ristorino_backend.services.reservas.Dto.CrearReservaDesdeRistorinoResponseDTO;
import ar.edu.ubp.das.ristorino_backend.services.reservas.Dto.CrearReservaRestauranteDTO;

@Service
public class ReservasService {
  @Autowired
  private ConfiguracionRepository configuracionRepository;
  @Autowired
  private ReservasRepository reservasRepository;
  @Autowired
  private ClienteRepository clientesRepository;
  @Autowired
  private CostosRepository costosRepository;

  @Transactional
  public CrearReservaDesdeRistorinoResponseDTO crearReserva(CrearReservaRequestBean request, Integer nroCliente) {

    // Obtener costo dinámico
    BigDecimal costoReserva = costosRepository
        .obtenerCostoPorTipo("RESERVA")
        .getMonto();

    // Obtenemos todo el cliente
    ClienteBean cliente = clientesRepository.obtenerClientePorId(
        nroCliente);
    System.out.println("CLIENTE OBTENIDO: " + cliente.getNombre());

    // Obtenemos la configuracion
    ConfigBean config = configuracionRepository
        .obtenerConfiguracionRestaunte(request.getNroRestaurante());

    // Armamos DTO de RESERVA
    CrearReservaRestauranteDTO reservaDTO = new CrearReservaRestauranteDTO();
    reservaDTO.setNroCliente(nroCliente);
    reservaDTO.setFechaReserva(request.getFechaReserva().toString());
    reservaDTO.setNroSucursal(request.getNroSucursal());
    reservaDTO.setCodZona(request.getCodZona());
    reservaDTO.setHoraReserva(request.getHoraReserva().toString());
    reservaDTO.setCantAdultos(request.getCantAdultos());
    reservaDTO.setCantMenores(request.getCantMenores());
    reservaDTO.setCostoReserva(costoReserva.doubleValue());

    // Armamos DTO de CLIENTE
    ClienteRestauranteDTO clienteDTO = new ClienteRestauranteDTO();
    clienteDTO.setNroCliente(cliente.getNroCliente());
    clienteDTO.setApellido(cliente.getApellido());
    clienteDTO.setNombre(cliente.getNombre());
    clienteDTO.setCorreo(cliente.getCorreo());
    clienteDTO.setTelefonos(cliente.getTelefonos());

    // Wrapper (cliente + reserva)
    CrearReservaConClienteDTO payload = new CrearReservaConClienteDTO();
    payload.setCliente(clienteDTO);
    payload.setReserva(reservaDTO);

    CrearReservaDesdeRistorinoResponseDTO response = new ApiHandler(config, "CrearReserva").execute(payload,
        new TypeToken<CrearReservaDesdeRistorinoResponseDTO>() {
        }.getType());

    if (response == null || response.getCodReservaSucursal() == null)
      throw new ResponseStatusException(HttpStatus.BAD_GATEWAY,
          "No se pudo crear la reserva en el restaurante");

    String codReservaSucursal = response.getCodReservaSucursal();

    // Insertamos en ristorino
    reservasRepository.crearReservaRestaurante(
        nroCliente,
        request.getFechaReserva(),
        request.getNroRestaurante(),
        request.getNroSucursal(),
        request.getCodZona(),
        request.getHoraReserva(),
        request.getCantAdultos(),
        request.getCantMenores(),
        "CONF",
        costoReserva.doubleValue(),
        codReservaSucursal);

    return response;
  }
}
