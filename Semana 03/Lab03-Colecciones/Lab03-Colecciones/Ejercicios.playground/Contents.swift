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
