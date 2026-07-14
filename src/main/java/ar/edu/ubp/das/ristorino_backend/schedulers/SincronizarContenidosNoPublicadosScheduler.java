package ar.edu.ubp.das.ristorino_backend.schedulers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import ar.edu.ubp.das.ristorino_backend.services.contenidos.ContenidosService;

@Component
public class SincronizarContenidosNoPublicadosScheduler {

  @Autowired
  private ContenidosService contenidosService;

  @Scheduled(fixedRate = 20000)
  public void ejecutarSincronizacionDeContenidosNoPublicados() {
    try {
      contenidosService.sincronizarContenidosNoPublicados();
      System.out.println("Proceso de ejecutarSincronizacionDeContenidosNoPublicados ejecutado correctamente.");
    } catch (Exception e) {
      System.err.println("Error en ejecutarSincronizacionDeContenidosNoPublicados: " + e.getMessage());
    }
  }

}
