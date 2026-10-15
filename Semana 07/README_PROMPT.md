# Prompt simulado para el caso de culturas peruanas

Este prompt es una reconstrucción didáctica para documentar cómo se podría solicitar el caso a una IA. No es una transcripción literal de una consulta realizada.

## Contexto

Estoy desarrollando el Laboratorio 07 de Programación en Móviles Avanzado. Ya trabajé con UIKit, Storyboard, UITableView, celdas reutilizables, outlets, protocolos y segues.

## Rol

Actúa como un asistente de programación iOS y explica una solución apropiada para un estudiante que está aprendiendo estos conceptos.

## Tarea

Crea el proyecto Semana07_03_CulturasPeruanas dentro de SEMANA_07 de mi portafolio, en la rama ai-assisted. Resuelve el caso a desarrollar de la guía GLAB-S07-JLEONS-2026-2:

1. Una pantalla con UITableView que muestre varias culturas peruanas.
2. Cada celda debe incluir el nombre y una imagen representativa.
3. Al tocar una cultura, navegar mediante un segue Show a una vista de detalle.
4. El detalle debe mostrar nombre, región del Perú, descripción breve e imagen.
5. Pasar el modelo seleccionado con prepare(for:sender:).
6. Conectar dataSource, delegate y outlets desde el Storyboard.
7. Usar una celda reutilizable y constraints superior, inferior, izquierdo y derecho de la tabla a 0 respecto de la Safe Area.
8. Guardar las imágenes en Assets para que la app funcione sin internet.

Usa como ejemplos Inca, Nazca, Chavín y Paracas. Obtén imágenes representativas con licencia reutilizable y documenta su autor, fuente y licencia.

## Formato esperado

Entrega el proyecto editable en Xcode con el modelo, los controladores, la clase de celda, Storyboards y recursos organizados por archivo. Incluye un README que explique el funcionamiento, cómo ejecutar y dónde están las evidencias. Conserva commits progresivos para creación del proyecto, lista, detalle y documentación.

## Criterios de revisión

- Compila y se ejecuta en iPhone 16.
- Las cuatro culturas muestran su propia imagen.
- El detalle corresponde a la fila seleccionada.
- El botón de volver permite regresar y elegir otra cultura.
- Ningún outlet queda desconectado.
- El repositorio incluye fuentes y recursos necesarios, con las atribuciones.
- Las capturas muestran la lista y los detalles ejecutados.

## Revisión de la solución implementada

Se revisaron la clase Cultura, la reutilización de culturaCell, sus outlets, la conexión del segue mostrarDetalleCultura y el envío de la cultura seleccionada. El modelo se implementó como struct porque el detalle recibe una copia para mostrarla. La navegación permanece en el Storyboard.
