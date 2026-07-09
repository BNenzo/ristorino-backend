package ar.edu.ubp.das.ristorino_backend.services.clientes;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ar.edu.ubp.das.ristorino_backend.repositories.clientes.ClienteRepository;
import ar.edu.ubp.das.ristorino_backend.services.clientes.Dto.RegistrarClienteRequestDTO;
import ar.edu.ubp.das.ristorino_backend.utils.PasswordUtils;

@Service
public class ClientesService {

  @Autowired
  private ClienteRepository clienteRepository;

  @Transactional
  public Integer registrarClienteConPreferencias(RegistrarClienteRequestDTO request) {

    // Convertir preferencias [{cod_categoria, nro_valor_dominio}] → "tc:1,ea:2,est:5"
    String preferenciasCsv = request.getPreferencias().stream()
        .map(p -> p.getCod_categoria() + ":" + p.getNro_valor_dominio())
        .collect(Collectors.joining(","));

    // Hashear password
    String hashedPassword = PasswordUtils.hash(request.getPassword());

    // Llamar al SP
    Map<String, Object> result = clienteRepository.registrarClienteConPreferencias(
        request.getApellido(),
        request.getNombre(),
        request.getDni(),
        hashedPassword,
        request.getCorreo(),
        request.getTelefono(),
        request.getNroLocalidad(),
        preferenciasCsv);

    System.out.println("RESULT MAP COMPLETO: " + result);

    // Obtener result-set real
    List<Map<String, Object>> resultSet = (List<Map<String, Object>>) result.get("#result-set-1");

    if (resultSet == null || resultSet.isEmpty()) {
      throw new RuntimeException("Sin respuesta del SP");
    }

    Map<String, Object> row = resultSet.get(0);

    Integer success = Integer.valueOf(row.get("success").toString());

    if (success == 0) {
      String message = row.get("message") != null
          ? row.get("message").toString()
          : "Error al registrar cliente";

      throw new RuntimeException(message);
    }

    // Retornar nro_cliente generado
    return Integer.valueOf(row.get("nro_cliente").toString());
  }
}
