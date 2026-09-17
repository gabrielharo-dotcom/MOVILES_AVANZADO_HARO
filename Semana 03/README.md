# Requerimientos Funcionales - Sistema de Consulta y Gestión del Metro de Lima

## RF-01 - Búsqueda de Estaciones
Permitir la localización individual de estaciones o paraderos por nombre, mostrando su información principal, línea a la que pertenecen, estado y posibles conexiones con otros sistemas de transporte.

## RF-02 - Ficha de Accesibilidad y Servicio
Mostrar la línea correspondiente a cada estación, su estado de operación, disponibilidad de ascensores o infraestructura accesible, así como información adicional sobre conexiones con el Metropolitano u otras líneas.

## RF-03 - Listado de Redes
Permitir consultar el inventario completo de estaciones agrupadas por Línea 1, Línea 2, Ramal Línea 4, Metropolitano y líneas adicionales creadas mediante el modo administrador.

## RF-04 - Estado de la Línea 2
Clasificar las 27 estaciones consideradas para la Línea 2 según su estado, diferenciando entre estaciones operativas, estaciones en construcción y estaciones correspondientes a futuras etapas.

## RF-05 - Identificación de Empalmes
Mostrar los principales puntos de conexión entre la Línea 1, Línea 2, Ramal Línea 4 y Metropolitano, indicando si se trata de un intercambio integrado, una conexión futura o un traslado que requiere recorrido por superficie.

## RF-06 - Asistente de Destinos
Sugerir al usuario la estación o paradero más conveniente para llegar a determinados puntos de interés, como Aeropuerto Jorge Chávez, Centro Histórico, San Isidro, Miraflores, Gamarra, Museo de la Nación o Estadio Nacional.

## RF-07 - Cálculo de Itinerarios mediante BFS
Utilizar el algoritmo de búsqueda en anchura, BFS, para calcular una ruta entre una estación de origen y una estación o destino, considerando tanto rutas actualmente disponibles como rutas futuras de la red.

## RF-08 - Estimación de Tiempo de Viaje
Calcular una duración aproximada del viaje considerando el número de estaciones recorridas, el sistema de transporte utilizado y los posibles cambios entre líneas.

## RF-09 - Seguimiento del Viaje
Permitir al usuario indicar en qué estación del recorrido se encuentra actualmente para calcular cuántas estaciones faltan hasta el destino y estimar el tiempo restante del viaje.

## RF-10 - Detección de Conexiones entre Líneas
Identificar automáticamente si el usuario necesita utilizar una o varias líneas para llegar a su destino, indicando los puntos aproximados donde debe realizar un cambio de línea o sistema de transporte.

## RF-11 - Información al Llegar a una Estación
Mostrar al usuario información relacionada con lo que puede encontrar al llegar a su estación de destino, como servicios disponibles, accesos, zonas cercanas, lugares de interés y posibles conexiones.

## RF-12 - Simulación de Próximos Servicios
Generar tiempos aproximados de llegada del siguiente tren o bus únicamente para estaciones operativas, considerando diferentes rangos de frecuencia según el sistema utilizado.

## RF-13 - Gestión de Tarjeta de Transporte
Permitir al usuario consultar la información de una tarjeta de transporte simulada, incluyendo su número, saldo disponible y cantidad de viajes realizados.

## RF-14 - Recarga de Tarjeta
Permitir ingresar un monto de recarga y actualizar automáticamente el saldo de la tarjeta, validando que el monto ingresado sea mayor que cero.

## RF-15 - Simulación de Cobro de Viaje
Calcular una tarifa simulada según el origen, destino y línea utilizada, descontando dicho importe del saldo disponible de la tarjeta.

## RF-16 - Validación de Saldo
Verificar que la tarjeta tenga saldo suficiente antes de realizar un cobro y mostrar un mensaje de saldo insuficiente cuando el importe disponible no permita completar la operación.

## RF-17 - Acceso a Modo Administrador
Incorporar un modo administrador protegido mediante contraseña para restringir las funciones de modificación de la red de transporte.

## RF-18 - Agregar Estaciones
Permitir al administrador añadir nuevas estaciones al final de una línea existente, incorporándolas automáticamente a la estructura utilizada por el sistema.

## RF-19 - Inserción de Estaciones entre Estaciones Existentes
Permitir al administrador seleccionar un tramo de una línea e insertar una nueva estación entre dos estaciones existentes, manteniendo el orden correcto de la red.

## RF-20 - Creación de Nuevas Líneas
Permitir al administrador crear una línea completamente nueva, indicando su nombre, número de estaciones y nombres de cada una de ellas.

## RF-21 - Actualización Dinámica de la Red
Incorporar automáticamente las estaciones y líneas creadas desde el modo administrador al grafo utilizado por el algoritmo BFS, permitiendo que puedan participar inmediatamente en nuevos cálculos de rutas.

## RF-22 - Consulta de Red Administrativa
Permitir al administrador visualizar todas las líneas registradas y el orden de las estaciones pertenecientes a cada una de ellas, incluyendo las líneas creadas durante la ejecución del programa.

## RF-23 - Compatibilidad de Nuevas Líneas con Servicios
Permitir que las líneas creadas por el administrador puedan participar en la simulación de próximos servicios, estimación de tiempos, cálculo de rutas y cobros simulados.

## RF-24 - Control de Errores
Validar las entradas ingresadas por el usuario, como estaciones inexistentes, opciones incorrectas, montos negativos, selección de tramos inválidos, saldo insuficiente o intentos de acceso incorrectos al modo administrador, evitando que el programa se cierre inesperadamente.
