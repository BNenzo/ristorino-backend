package ar.edu.ubp.das.ristorino_backend.schedulers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import ar.edu.ubp.das.ristorino_backend.services.contenidos.ContenidosService;

@Component
public class GenerarContenidoIAScheduler {
  @Autowired
  private ContenidosService contenidosService;

  @Scheduled(fixedRate = 15000)
  public void ejecutarGenerarContenidoIA() {
    try {
      contenidosService.generarContenidosIA();
      System.out.println("Proceso de ejecutarGenerarContenidoIA ejecutado correctamente.");
    } catch (Exception e) {
      System.err.println("Error en ejecutarGenerarContenidoIA: " + e.getMessage());
    }
  }
}
