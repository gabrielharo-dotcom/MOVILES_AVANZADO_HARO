// Desarrollado por: Gabriel Haro
// Ejercicio 6: Gestión de Notas (con IA)

import Foundation // Importa las funciones base de Swift como readLine

// Solicita la cantidad de alumnos a procesar
print("¿Cuántos alumnos registrará?") // Muestra el mensaje en la consola
let cantidadAlumnos = Int(readLine() ?? "") ?? 0 // Lee la entrada y la convierte a número entero

// Diccionario principal para almacenar el nombre como clave y sus 3 notas como un arreglo de Doubles
var registroNotas: [String: [Double]] = [:] // Inicializa el diccionario vacío

// Bucle para capturar los datos de cada alumno según la cantidad ingresada
for i in 1...cantidadAlumnos { // Iterador del 1 hasta el total de alumnos
    print("\nNombre del alumno \(i):") // Pide el nombre del alumno actual
    let nombreAlumno = readLine() ?? "" // Guarda la cadena leída del usuario
    
    var notasAlumno: [Double] = [] // Arreglo temporal para acumular las 3 notas
    
    // Bucle interno para solicitar las 3 notas
    for j in 1...3 { // Se repite exactamente 3 veces por alumno
        print("Ingrese la nota \(j) para \(nombreAlumno):") // Mensaje para la nota específica
        let notaIngresada = Double(readLine() ?? "") ?? 0.0 // Convierte la nota a Double
        notasAlumno.append(notaIngresada) // Agrega la nota al arreglo de notas
    } // Fin del bucle de notas
    
    registroNotas[nombreAlumno] = notasAlumno // Asigna el arreglo de notas a la clave del alumno
} // Fin del bucle de registro

print("\n===== REPORTE GENERAL DE NOTAS =====") // Encabezado de la lista final de resultados

// Variables acumuladoras para cálculo de estadísticas generales
var sumaNotasTotales = 0.0 // Mantiene la suma de todas las notas escritas
var conteoNotasTotales = 0 // Mantiene el número total de notas procesadas
var listaPromedios: [(nombre: String, promedio: Double, categoria: String)] = [] // Tupla para ordenar resultados
var notaMaxGeneral = -1.0 // Variable para determinar la nota más alta de la clase
var notaMinGeneral = 21.0 // Variable para determinar la nota más baja de la clase
var totalAprobados = 0 // Contador de alumnos aprobados
var totalAlumnosProcesados = 0 // Contador de alumnos evaluados

// Recorre cada elemento guardado en el diccionario de notas
for (alumno, notas) in registroNotas { // Extrae la clave (alumno) y el valor (arreglo de notas)
    let sumaIndividual = notas.reduce(0, +) // Suma todos los elementos del arreglo de notas
    let promedioIndividual = sumaIndividual / Double(notas.count) // Calcula el promedio del alumno
    
    // Evalúa la nota máxima y mínima general encontradas hasta el momento
    for nota in notas { // Revisa cada nota individualmente
        if nota > notaMaxGeneral { notaMaxGeneral = nota } // Actualiza la nota más alta
        if nota < notaMinGeneral { notaMinGeneral = nota } // Actualiza la nota más baja
        sumaNotasTotales += nota // Suma al acumulador general
        conteoNotasTotales += 1 // Incrementa el conteo global de notas
    } // Fin de evaluación de notas individuales
    
    // Clasifica el rendimiento utilizando la estructura switch
    var clasificacion = "" // Variable para guardar la categoría textual
    switch promedioIndividual { // Evalúa según el valor numérico del promedio
    case 18.0...20.0: // Si el promedio está entre 18 y 20
        clasificacion = "Excelente" // Asigna la categoría Excelente
    case 14.0..<18.0: // Si el promedio está entre 14 y 17.99
        clasificacion = "Bueno" // Asigna la categoría Bueno
    case 13.0..<14.0: // Si el promedio está entre 13 y 13.99
        clasificacion = "Aprobado" // Asigna la categoría Aprobado
    default: // Para cualquier valor menor a 13
        clasificacion = "Desaprobado" // Asigna la categoría Desaprobado
    } // Fin de clasificación con switch
    
    // Contabiliza el número total de aprobados para el porcentaje final
    if promedioIndividual >= 13.0 { // Condición para aprobar la materia
        totalAprobados += 1 // Suma 1 al contador de aprobados
    } // Fin de validación de estado
    
    totalAlumnosProcesados += 1 // Incrementa el total de alumnos procesados
    listaPromedios.append((nombre: alumno, promedio: promedioIndividual, categoria: clasificacion)) // Agrega los datos a la tupla
} // Fin del recorrido del diccionario

// Ordena la lista de alumnos según su promedio de mayor a menor
let listaOrdenada = listaPromedios.sorted { $0.promedio > $1.promedio } // Comparador descendente por promedio

print("\n--- Alumnos Ordenados por Promedio (Mayor a Menor) ---") // Título del reporte ordenado
for estudiante in listaOrdenada { // Recorre la lista de tuplas previamente ordenada
    print("Alumno: \(estudiante.nombre) | Promedio: \(estudiante.promedio) | Estado: \(estudiante.categoria)") // Muestra la línea de información
} // Fin de la impresión de alumnos ordenados

print("\n===== ESTADÍSTICAS GENERALES DE LA CLASE =====") // Sección final de métricas
if conteoNotasTotales > 0 { // Valida que existan datos cargados para evitar división entre cero
    let promedioGeneralClase = sumaNotasTotales / Double(conteoNotasTotales) // Promedio global de la clase
    let porcentajeAprobados = (Double(totalAprobados) / Double(totalAlumnosProcesados)) * 100.0 // Porcentaje de aprobación
    
    print("Promedio General de la clase: \(promedioGeneralClase)") // Muestra el promedio general
    print("Nota más alta registrada: \(notaMaxGeneral)") // Muestra la nota máxima global
    print("Nota más baja registrada: \(notaMinGeneral)") // Muestra la nota mínima global
    print("Porcentaje de alumnos aprobados: \(porcentajeAprobados)%") // Muestra el porcentaje de aprobación
} else { // Si no se procesó ningún registro
    print("No se ingresaron datos suficientes para calcular estadísticas.") // Alerta por falta de datos
} // Fin de la validación de estadísticas

// Desarrollado por: Gabriel Haro
// Ejercicio 7: Inventario con menú (con IA)

// Solicita al usuario la cantidad inicial de productos a registrar en el inventario
print("¿Cuántos productos registrará en el inventario inicial?") // Imprime instrucción en la consola
let cantidadProductos = Int(readLine() ?? "") ?? 0 // Lee la entrada del usuario y la convierte a Int con fallback a 0

// Diccionarios principales para estructurar la base de datos en memoria del inventario
var preciosInventario: [String: Double] = [:] // Almacena el nombre del producto como clave y su precio como valor
var stocksInventario: [String: Int] = [:] // Almacena el nombre del producto como clave y su stock como valor

// Bucle para poblar los productos iniciales ingresados por el usuario
for i in 1...cantidadProductos { // Ejecuta un bucle cerrado desde 1 hasta el total indicado
    print("\n--- Registro de Producto \(i) ---") // Título del bloque de registro para el producto actual
    print("Nombre del producto:") // Pide el nombre descriptivo del ítem
    let nombreProd = readLine() ?? "" // Guarda la cadena recibida desde la consola de comandos
    
    print("Precio del producto (S/.):") // Pide el costo monetario unitario
    let precioProd = Double(readLine() ?? "") ?? 0.0 // Convierte el texto capturado a Double flotante
    
    print("Stock disponible (unidades):") // Pide la cantidad física disponible en almacén
    let stockProd = Int(readLine() ?? "") ?? 0 // Convierte la entrada a un número entero
    
    preciosInventario[nombreProd] = precioProd // Inserta el precio asociado a la clave en el diccionario de precios
    stocksInventario[nombreProd] = stockProd // Inserta el stock asociado a la clave en el diccionario de stocks
} // Fin del bucle interactivo de carga inicial

// Variable de control booleana para mantener activo el menú interactivo while
var continuarEnMenu = true // Define el estado inicial del ciclo de opciones del menú

// Bucle principal para despliegue y navegación del menú interactivo de gestión
while continuarEnMenu { // Se ejecutará continuamente mientras continuarEnMenu sea verdadero
    print("\n==========================================") // Separador estético para el menú
    print("      MENÚ DE GESTIÓN DE INVENTARIO       ") // Título del menú interactivo
    print("==========================================") // Separador inferior del encabezado
    print("1) Ver inventario completo") // Opción para listar todos los artículos registrados
    print("2) Buscar producto por nombre") // Opción para consultar el estado de un artículo
    print("3) Filtrar productos con stock bajo (< 5)") // Opción para ver alertas de reposición
    print("4) Calcular valor total del inventario") // Opción para reporte económico global
    print("5) Salir del programa") // Opción para finalizar el ciclo de control
    print("Seleccione una opción (1-5):") // Mensaje de solicitud de opción al usuario
    
    let opcionSeleccionada = readLine() ?? "" // Lee la opción tipeada por el usuario
    
    switch opcionSeleccionada { // Evalúa la opción ingresada contra los casos soportados
    case "1": // Caso para listar el contenido total del almacén
        print("\n--- INVENTARIO COMPLETO ---") // Encabezado de la lista general
        if preciosInventario.isEmpty { // Verifica si no existen productos guardados
            print("El inventario está actualmente vacío.") // Notifica la falta de datos
        } else { // Si existen productos guardados en los diccionarios
            for (nombre, precio) in preciosInventario { // Recorre el diccionario extraendo clave y precio
                let stock = stocksInventario[nombre] ?? 0 // Obtiene el stock correspondiente de forma segura
                print("• Producto: \(nombre) | Precio: S/. \(precio) | Stock: \(stock) unidades") // Muestra la línea
            } // Fin del recorrido del catálogo
        } // Fin de validación de inventario vacío
        
    case "2": // Caso para realizar búsquedas específicas por nombre
        print("\n--- BÚSQUEDA DE PRODUCTO ---") // Encabezado de la herramienta de búsqueda
        print("Ingrese el nombre del producto a buscar:") // Pide el criterio de búsqueda
        let busqueda = readLine() ?? "" // Guarda el término tipeado por el cliente
        
        if let precioEncontrado = preciosInventario[busqueda] { // Búsqueda segura en el diccionario de precios
            let stockEncontrado = stocksInventario[busqueda] ?? 0 // Búsqueda del stock asociado
            print("✓ Encontrado: \(busqueda)") // Notifica el hallazgo exitoso
            print("  Precio unitario: S/. \(precioEncontrado)") // Imprime el precio unitario
            print("  Stock disponible: \(stockEncontrado) unidades") // Imprime las unidades disponibles
        } else { // En caso la clave no exista dentro del diccionario
            print("✕ El producto '\(busqueda)' no existe en el inventario.") // Mensaje de error en búsqueda
        } // Fin de evaluación de la búsqueda
        
    case "3": // Caso para reporte de alertas por inventario reducido
        print("\n--- PRODUCTOS CON STOCK BAJO (< 5) ---") // Título del reporte crítico
        var encontradosBajos = 0 // Contador para verificar si se halló al menos uno
        for (nombre, stock) in stocksInventario { // Recorre los elementos del diccionario de stocks
            if stock < 5 { // Evalúa la condición de vulnerabilidad de stock
                let precio = preciosInventario[nombre] ?? 0.0 // Recupera el precio asociado
                print("⚠️ Alerta: \(nombre) | Stock actual: \(stock) unidades | Precio: S/. \(precio)") // Muestra alerta
                encontradosBajos += 1 // Incrementa el contador de coincidencias
            } // Fin de evaluación de umbral
        } // Fin del recorrido de stocks
        if encontradosBajos == 0 { // Si no hubo ningún producto con stock menor a 5
            print("No se encontraron productos con stock crítico (todos tienen >= 5 unidades).") // Confirmación de stock sano
        } // Fin de validación de hallazgos
        
    case "4": // Caso para cálculo del valor acumulado monetario
        print("\n--- VALOR TOTAL DEL INVENTARIO ---") // Encabezado del balance contable
        var sumaTotalValor = 0.0 // Acumulador numérico en coma flotante
        for (nombre, precio) in preciosInventario { // Recorre los precios de los productos
            let stock = stocksInventario[nombre] ?? 0 // Asocia la cantidad de unidades en existencia
            sumaTotalValor += (precio * Double(stock)) // Multiplica precio por cantidad y acumula
        } // Fin del cálculo global
        print("El valor económico total acumulado en el almacén es: S/. \(sumaTotalValor)") // Imprime el balance final
        
    case "5": // Caso de salida ordenada de la aplicación
        print("\nSaliendo del sistema de inventario... ¡Hasta luego!") // Mensaje de despedida
        continuarEnMenu = false // Cambia la bandera para romper el ciclo del bucle while
        
    default: // Control de entradas inválidas por parte del usuario
        print("\nOpción no válida. Por favor, ingrese un número del 1 al 5.") // Notificación de selección errónea
    } // Fin del bloque de control switch
} // Fin del bucle interactivo del menú while
