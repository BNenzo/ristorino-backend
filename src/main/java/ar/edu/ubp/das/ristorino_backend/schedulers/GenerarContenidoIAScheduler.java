package ar.edu.ubp.das.ristorino_backend.schedulers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.core.JsonProcessingException;

import ar.edu.ubp.das.ristorino_backend.services.contenidos.ContenidosService;

@Component
public class GenerarContenidoIAScheduler {
  @Autowired
  private ContenidosService contenidosService;

  @Scheduled(fixedRate = 15000)
  public void ejecutarGenerarContenidoIA() throws JsonProcessingException {
    // contenidosService.generarContenidosIA();
    System.out.println("Proceso de ejecutarGenerarContenidoIA ejecutado correctamente.");

  }
}
