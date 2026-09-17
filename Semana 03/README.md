## Requerimientos Funcionales - Sistema de Consulta del Metro de Lima

1) RF-01 (Búsqueda de Estaciones): Permitir la localización individual de paraderos por nombre para desplegar sus detalles de interconexión y transbordo.

2) RF-02 (Ficha de Accesibilidad y Servicio): Desplegar la línea a la que pertenece cada estación, su estado de operación, la presencia de infraestructura accesible (elevadores/rampas) y eventuales coincidencias con el Metropolitano.

3) RF-03 (Listado de Redes): Consultar el inventario completo de estaciones agrupadas por Línea 1, Línea 2, Ramal L4 y el sistema Metropolitano.

4) RF-04 (Estado de la Línea 2): Categorizar las 27 paradas proyectadas para la Línea 2 según su estado actual (completadas y en servicio frente a las que están en proceso de construcción).

5) RF-05 (Identificación de Empalmes): Mapear los cruces intermodales de la Línea 2 y clarificar cuáles conexiones con la Línea 1 o Metropolitano requieren trayectos por superficie y no representan trasbordos integrados.

6) RF-06 (Asistente de Destinos): Sugerir la estación o paradero más conveniente según el punto de interés seleccionado por el usuario (p. ej., Aeropuerto, Centro Histórico, San Isidro, Miraflores, Gamarra o Estadio Nacional).

7) RF-07 (Cálculo de Itinerarios vía BFS): Implementar el algoritmo de búsqueda en anchura (BFS) para determinar trayectos presentes o futuros y proyectar la duración aproximada del recorrido.

8) RF-08 (Simulador de Arribos y Control de Errores): Generar tiempos de proximidad de trenes exclusivamente en estaciones activas, incorporando mecanismos de validación frente a entradas no válidas del usuario.

9) RF-09 (Diseño Modular para Entorno Móvil): Estructurar la lógica de negocio de forma desacoplada para asegurar su posterior reutilización en una aplicación móvil.
