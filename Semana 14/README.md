# Semana 14: Autenticación con Firebase

Laboratorio 14. App SwiftUI `Lab14IntroFirebase` que registra e inicia sesión con Firebase Authentication (correo y clave), y luego muestra un chat cuyos mensajes se guardan y se actualizan en tiempo real con Cloud Firestore.

| Actividad | Qué hace | Archivos |
|---|---|---|
| 01 · Autenticación | Sign Up, Sign In y Sign Out con correo y clave | `Lab14IntroFirebaseApp.swift`, `ContentView.swift`, `AuthView.swift` |
| 02 · Base de datos en tiempo real | Al iniciar sesión se abre la mensajería: enviar mensajes y verlos llegar al instante | `DatabaseService.swift`, `MessagesView.swift`, `AuthView.swift` |

## Configuración

- Proyecto de Firebase: `App01-Lab14`, con Authentication (Email/Password) y Firestore Database en modo de prueba.
- Bundle Identifier: `pe.edu.tecsup.dma.Lab14IntroFirebase`.
- Paquete `https://github.com/firebase/firebase-ios-sdk` (desde la versión 11.14.0) con FirebaseAuth, FirebaseCore, FirebaseDatabase y FirebaseFirestore.
- `GoogleService-Info.plist` va en la carpeta `Lab14IntroFirebase/Lab14IntroFirebase/`. No se sube al repositorio porque tiene la clave del proyecto de Firebase: cada quien descarga el suyo desde la consola.

## Cómo ejecutarla

1. Descargar `GoogleService-Info.plist` desde la consola de Firebase y copiarlo en `Lab14IntroFirebase/Lab14IntroFirebase/`.
2. Abrir `Lab14IntroFirebase/Lab14IntroFirebase.xcodeproj`. Xcode descarga el paquete de Firebase la primera vez.
3. Elegir un simulador y presionar **Cmd + R**.
4. Registrar un usuario con **Sign Up**, revisar que aparezca en Authentication y luego escribir mensajes. Los mensajes quedan en la colección `messages` de Firestore.

## Respuestas

**¿Para qué sirve cada paquete?**

| Paquete | Para qué sirve |
|---|---|
| FirebaseCore | La base de todos los servicios: `FirebaseApp.configure()` lee la configuración y conecta la app con el proyecto de Firebase |
| FirebaseAuth | Autenticación de usuarios: registro, inicio y cierre de sesión con correo y clave, y saber quién está conectado |
| FirebaseDatabase | Realtime Database: base de datos en la nube que guarda la información como un árbol JSON y la sincroniza en tiempo real |
| FirebaseFirestore | Cloud Firestore: base de datos NoSQL de colecciones y documentos, con consultas ordenadas y escucha de cambios en tiempo real. Es la que usa la actividad 2 |

**¿Cuál es la finalidad de `FirebaseApp.configure()`?**
Inicializa Firebase al arrancar la app: lee `GoogleService-Info.plist` y conecta la app con el proyecto. Se llama una sola vez en el `init()` de la App, antes de usar Auth o Firestore; sin esa llamada, cualquier servicio de Firebase falla.

**Métodos principales de `Auth.auth()` usados**

| Método | Qué hace |
|---|---|
| `createUser(withEmail:password:)` | Registra un usuario nuevo (Sign Up). La clave debe tener mínimo 6 caracteres |
| `signIn(withEmail:password:)` | Inicia sesión con un usuario registrado (Sign In) |
| `signOut()` | Cierra la sesión. Puede lanzar un error, por eso va con `try` |
| `addStateDidChangeListener` | Avisa cada vez que alguien inicia o cierra sesión; la app lo usa para mostrar el formulario o los mensajes |
| `currentUser` | El usuario conectado; `DatabaseService` toma de ahí el correo de quien envía el mensaje |

**¿Cuál es la ventaja de usar Firebase Database?**
No hace falta programar ni mantener un servidor: los datos se guardan en la nube y se sincronizan en tiempo real con todos los dispositivos. Cuando un usuario envía un mensaje, `addSnapshotListener` lo muestra al instante en los demás, sin recargar. Además se integra con Authentication para saber quién escribió cada dato.

**Tres servicios adicionales de Firebase para este proyecto**
1. **Cloud Messaging:** notificaciones push cuando llega un mensaje nuevo.
2. **Cloud Storage:** enviar imágenes o archivos en el chat.
3. **Crashlytics:** reportes de errores y cierres inesperados de la app.

## Conclusiones

1. Firebase Authentication resuelve el registro y el inicio de sesión con pocas líneas, sin servidor propio, y el listener de estado mantiene la pantalla sincronizada con la sesión.
2. Con Firestore y `addSnapshotListener`, los datos llegan a todos los usuarios en tiempo real; junto con `@Published` y `@StateObject`, SwiftUI redibuja la lista sola.
3. El archivo `GoogleService-Info.plist` conecta la app con el proyecto de Firebase y no debe subirse a un repositorio público. Las reglas de Firestore en modo de prueba solo sirven para desarrollo.

## Capturas

Pendientes.
