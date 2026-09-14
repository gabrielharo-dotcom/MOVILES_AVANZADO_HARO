# Prompts utilizados - Laboratorio 04

## Herramienta de IA utilizada

GeminiPro

## Caso 2B - Biblioteca

### Prompt 1 - Estructura principal

Estoy trabajando en un Playground de Swift y recién estamos viendo programación
orientada a objetos. Necesito una biblioteca con `enum EstadoLibro`, `struct Libro`
y `class Biblioteca`. La clase debe guardar un array de libros y tener los métodos
`agregar(libro:)`, `prestar(titulo:) -> Bool`, `devolver(titulo:) -> Bool` e
`inventario()`. Usa solamente enums, structs, clases, arrays, bucles, funciones,
condicionales y `switch`. No uses optionals, `guard let`, `firstIndex(where:)`,
`didSet`, propiedades calculadas ni genéricos. Dame primero la estructura y los
métodos, sin la simulación.

### Respuesta de la IA

Propuso los dos estados del libro, un inicializador que deja cada libro disponible
y una clase que recorre el array por índice para modificar el elemento correcto.

### Prompt 2 - Simulación

Ahora agrega una prueba con "Cien años de soledad", "La ciudad y los perros" y
"El Quijote". Presta "La ciudad y los perros", intenta prestarlo otra vez,
devuélvelo, presta "El Quijote", intenta prestar "El Principito" y muestra el
inventario. La salida debe coincidir exactamente con la guía.

### Respuesta de la IA

Agregó los tres libros y ejecutó las operaciones en el orden pedido. La salida
coincidió con los mensajes de préstamo, devolución, error e inventario final.

### Prompt 3 - Revisión final

Revisa todo el código y comenta cada línea explicando para qué sirve de verdad.
No pongas comentarios genéricos. Confirma también que no aparezcan closures,
optionals, `guard let`, `firstIndex(where:)`, `didSet`, `rawValue`, propiedades
calculadas ni genéricos.

### Respuesta de la IA

Entregó el código completo comentado línea por línea y mantuvo únicamente los
contenidos permitidos para esta semana.

### ¿Funcionó a la primera?

No completamente. La primera respuesta resolvió la estructura y los métodos,
pero todavía faltaban la simulación exacta y comentarios más claros. Se completó
con los dos pedidos siguientes.

### ¿Usó algo que no hemos visto en clase?

No. Desde el primer prompt se limitaron los recursos permitidos y en la revisión
final se comprobó que no hubiera sintaxis de semanas posteriores.

## Mi versión (Parte A) vs. la versión de la IA (Parte B)

### ¿Qué hizo distinto la IA respecto a mi solución?

La versión de la IA creó un `init` explícito para que cada libro empiece disponible
y guardó los tres libros en variables antes de agregarlos. Mi versión aprovechó el
valor inicial de `estado` y agregó cada libro de forma más directa.

### ¿Hay alguna línea de la IA que no entiendo del todo? ¿Cuál?

Al inicio tuve que revisar `libros[i].estado = .prestado`. Luego entendí que se
modifica el elemento dentro del array porque `Libro` es un `struct`; cambiar una
copia aparte no actualizaría el inventario.

### ¿Qué me pareció mejor de MI versión?

Es más corta y va directo a la solución, especialmente al crear y agregar los
libros.

### ¿Qué me pareció mejor de la versión de la IA?

El inicializador deja más claro el estado inicial y los comentarios ayudan a
seguir cada decisión del programa.
